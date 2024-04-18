import io
import os

from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from googleapiclient.errors import HttpError

from .constants import (
    DOWNLOADS_DIR, DOWNLOADABLE, ALT_CONTENT, UPDATE_DIR
)
from .exceptions import (
    ImproperFormat, InvalidCredentials
)


class Drive:
    @staticmethod
    def get_id_from_link(link):
        """
        Returns the file id for the file from the provided drive share 'link'
        """
        return link.split('/')[-2]

    def __init__(self, creds):
        """
        Constructs a new interface with the drive API from the provided 'creds'
        """
        self.service = build("drive", "v3", credentials=creds)

    def get_file_name(self, file_id):
        """
        Returns the file name for the provided 'file_id'
        Throws HttpError if error occurs on fetch
        """
        file_metadata = self.service.files().get(
            fileId=file_id, fields='name'
        ).execute()
        return file_metadata['name']

    def get_file_bytes(self, file_id):
        """
        Returns the bytes for the provided 'file_id'
        Throws HttpError if error occurs on fetch
        """
        request = self.service.files().get_media(fileId=file_id)

        file = io.BytesIO()
        downloader = MediaIoBaseDownload(file, request)

        done = False
        while done is False:
            _, done = downloader.next_chunk()

        return file.getvalue()

    def download_file(self, file_id, path=None):
        """
        Downloads the provided 'file_id', placing the result in DOWNLOADS_DIR
            Named 'new_name' if provided, otherwise will be the original name
        Returns whether or not the download was successful
        """
        try:
            if path is None:
                path = os.path.join(DOWNLOADS_DIR, self.get_file_name(file_id))

            file_bytes = self.get_file_bytes(file_id)
            with open(path, 'wb') as f:
                f.write(file_bytes)

            return True
        except HttpError as error:
            print(f"An error occurred: {error}")
            return False

    def copy_content_and_download(self, languages, row, title, row_i):
        """
        TODO
        """
        content = {}
        for i in range(len(languages)):
            if 1 + i < len(row):
                if row[0] in DOWNLOADABLE:
                    # Make specific subfolder for this page
                    path = UPDATE_DIR
                    if not os.path.exists(path):
                        os.makedirs(path)

                    # Need to download
                    [link, follow] = (row[1 + i] + ' ').split(' ', 1)
                    id = Drive.get_id_from_link(link)

                    try:
                        name = self.get_file_name(id)
                        file_name = f"{title}-{row_i+1}-{languages[i]}-{name}"
                        file_path = os.path.join(
                            path, file_name
                        )
                        print(file_path)
                        self.download_file(id, file_path)
                    except HttpError as e:
                        error_content = e.content.decode("utf-8")
                        if "Invalid Credentials" in error_content:
                            raise InvalidCredentials(f"No download permissions for link: {row[1 + i]}")
                        elif "File not found" in error_content:
                            raise ImproperFormat(f"Invalid file link: {row[1 + i]}")
                        else:
                            raise e

                    if row[0] in ALT_CONTENT:
                        # Handle alt text
                        content[languages[i]] = {
                            "path": file_name,
                            "alt": follow.strip()
                        }
                    else:
                        # No alt just put the path in
                        content[languages[i]] = file_name
                else:
                    # No need to download, just copy
                    content[languages[i]] = row[1+i]
            else:
                # No content at all
                content[languages[i]] = ""
        return content
