import io
import os

from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from googleapiclient.errors import HttpError

from .constants import (
    DOWNLOADS_DIR
)


class Drive:
    service = None

    @staticmethod
    def get_id_from_link(link):
        """
        Returns the file id for the file from the provided drive share 'link'
        """
        return link.split('/')[-2]

    @staticmethod
    def set_creds(creds):
        """
        Constructs a new interface with the drive API from the provided 'creds'
        """
        Drive.service = build("drive", "v3", credentials=creds)

    @staticmethod
    def get_file_name(file_id=None, link=None):
        """
        Returns the file name for the provided 'file_id'
        Throws HttpError if error occurs on fetch
        """
        if link is not None:
            file_id = Drive.get_id_from_link(link)

        file_metadata = Drive.service.files().get(
            fileId=file_id, fields='name'
        ).execute()
        return file_metadata['name']

    @staticmethod
    def get_file_bytes(file_id):
        """
        Returns the bytes for the provided 'file_id'
        Throws HttpError if error occurs on fetch
        """
        request = Drive.service.files().get_media(fileId=file_id)

        file = io.BytesIO()
        downloader = MediaIoBaseDownload(file, request)

        done = False
        while done is False:
            _, done = downloader.next_chunk()

        return file.getvalue()

    @staticmethod
    def download_file_id(file_id, path=None):
        """
        Downloads the provided 'file_id', placing the result in DOWNLOADS_DIR
            Named 'new_name' if provided, otherwise will be the original name
        Returns whether or not the download was successful
        """
        try:
            if path is None:
                path = os.path.join(DOWNLOADS_DIR, Drive.get_file_name(file_id))

            dir_path = os.path.dirname(path)
            if not os.path.exists(dir_path):
                os.makedirs(dir_path)

            file_bytes = Drive.get_file_bytes(file_id)
            with open(path, 'wb') as f:
                f.write(file_bytes)
        except HttpError as e:
            error_content = e.content.decode("utf-8")
            if "Invalid Credentials" in error_content:
                raise Exception("No download permissions for link")
            elif "File not found" in error_content:
                raise Exception("Invalid file link")
            else:
                raise e

    @staticmethod
    def download_file_link(link, path=None):
        if not os.path.exists(path):
            id = Drive.get_id_from_link(link)
            return Drive.download_file_id(id, path)
