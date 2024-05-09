from googleapiclient.discovery import build
from googleapiclient.errors import HttpError


class Sheets:
    service = None

    @staticmethod
    def get_id_from_link(link):
        """
        TODO
        """
        return link.split('/')[-2]

    @staticmethod
    def set_creds(creds):
        """
        TODO
        """
        Sheets.service = build("sheets", "v4", credentials=creds)

    @staticmethod
    def get_sheets(spreadsheet_id):
        """
        Returns a map for title -> sheetId for all subsheets in the provided
        spreadsheet
        """
        result = (
            Sheets.service.spreadsheets()
            .get(spreadsheetId=spreadsheet_id)
            .execute()
        )
        return [sheet['properties']['title'] for sheet in result['sheets']]

    @staticmethod
    def get_values(spreadsheet_id, range, sheet=None):
        """
        Returns 2d array of values from provided spreadsheet within the
        given range. None if there's an error
        """
        try:
            result = (
                Sheets.service.spreadsheets()
                .values()
                .get(spreadsheetId=spreadsheet_id, range=range)
                .execute()
            )
            return result.get("values", [])
        except HttpError as error:
            print(f"An error occurred: {error}")
            return None
