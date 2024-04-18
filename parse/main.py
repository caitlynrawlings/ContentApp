import shutil

from google.oauth2 import service_account

from src.drive import Drive
from src.sheets import Sheets
from src.constants import (
    CREDENTIALS_FILE, UPDATE_DIR
)


def load_credentials(scopes):
    return service_account.Credentials.from_service_account_file(
        CREDENTIALS_FILE,
        scopes=scopes
    )


def main():
    creds = load_credentials([
        'https://www.googleapis.com/auth/drive',
        'https://www.googleapis.com/auth/spreadsheets'
    ])

    spreadsheet_link = "https://docs.google.com/spreadsheets/d/1tu5G4pl6Wn2uOx3CbrUiJHEZy2e_8F2bPn8Ry6HJYJ4/edit?usp=sharing"

    Sheets(creds).parse_to_json(
        Drive(creds),
        Sheets.get_id_from_link(spreadsheet_link)
    )
    # TODO: Maybe change this when testing the pipeline jic of permission errors
    shutil.rmtree(UPDATE_DIR, ignore_errors=True)


if __name__ == "__main__":
    main()