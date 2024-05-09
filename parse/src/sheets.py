import os
import shutil
import json

from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

from src.constants import (
    SKIPPED_SHEETS, MAX_ROWS, PARSED_JSON, DOWNLOADS_DIR, UPDATE_DIR
)
from src.parser import Parser


class Sheets:
    @staticmethod
    def get_id_from_link(link):
        return link.split('/')[-2]

    def __init__(self, creds):
        self.service = build("sheets", "v4", credentials=creds)

    def get_sheets(self, spreadsheet_id):
        """
        Returns a map for title -> sheetId for all subsheets in the provided
        spreadsheet
        """
        result = (
            self.service.spreadsheets()
            .get(spreadsheetId=spreadsheet_id)
            .execute()
        )
        return [sheet['properties']['title'] for sheet in result['sheets']]

    def get_values(self, spreadsheet_id, range, sheet=None):
        """
        Returns 2d array of values from provided spreadsheet within the
        given range. None if there's an error
        """
        try:
            result = (
                self.service.spreadsheets()
                .values()
                .get(spreadsheetId=spreadsheet_id, range=range)
                .execute()
            )
            return result.get("values", [])
        except HttpError as error:
            print(f"An error occurred: {error}")
            return None

    @staticmethod
    def convert_page_data(data, title):
        """
        TODO
        """
        languages = data[0][2:]
        page_info = {
            "id": title,
            "title": {
                languages[i]: data[1][2+i] for i in range(len(languages))
            },
            "content": [
                Parser.parse(languages, data[2:][row_i], row_i, title)
                for row_i in range(len(data[2:]))
            ]
        }
        return page_info

    def parse_to_json(self, spreadsheet_id):
        """
        TODO
        """
        # 1. Get all sheets
        sheets = self.get_sheets(spreadsheet_id)
        if "Languages" not in sheets:
            raise Exception("Google Sheet misssing 'Languages' page")

        # 2. Get expected languages
        languages_page = self.get_values(spreadsheet_id, "Languages!1:2")
        json_data = {
            "languages": [{
                "language": languages_page[0][i],
                "direction": (Parser.get_acronym(languages_page[1][i])
                              if i < len(languages_page[1]) else "")
            } for i in range(len(languages_page[0]))],
            "pages": []
        }

        # 3. Get data and parse
        for sheet in sheets:
            if sheet in SKIPPED_SHEETS:
                continue

            data = self.get_values(spreadsheet_id, f"{sheet}!1:{MAX_ROWS}")
            if data[0][2:] != languages_page[0]:
                raise Exception(f"Provided sheet [{sheet}] doesn't include all languages: {data[0][2:]} != {languages}")

            # Make sure every page has a title in every language
            if len(data[1][2:]) != len(languages_page[0]):
                raise Exception(f"Provided sheet [{sheet}] doesn't include a title in all languages: {data[1][2:]} != {len(languages)} element(s)")

            json_data['pages'].append(
                Sheets.convert_page_data(data, sheet)
            )

        # 4. Save to file
        with open(PARSED_JSON, 'w') as f:
            json.dump(json_data, f, indent=4)

        # 5. Rename update to downloads
        shutil.rmtree(DOWNLOADS_DIR)
        os.rename(UPDATE_DIR, DOWNLOADS_DIR)

        shutil.rmtree(UPDATE_DIR, ignore_errors=True)
        return True
