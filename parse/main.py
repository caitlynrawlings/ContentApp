import shutil
import json
import os

from google.oauth2 import service_account

from src.drive import Drive
from src.sheets import Sheets
from src.constants import (
    ENVIRONMENT_API_KEY, UPDATE_DIR, SPREADSHEET_LINK
)


def load_credentials(scopes):
    credentials_dict = json.loads(json.loads(
        os.environ.get(ENVIRONMENT_API_KEY)
    ))

    return service_account.Credentials.from_service_account_info(
        credentials_dict,
        scopes=scopes
    )


def main():
    creds = load_credentials([
        'https://www.googleapis.com/auth/drive',
        'https://www.googleapis.com/auth/spreadsheets'
    ])

    Drive.set_creds(creds)
    Sheets(creds).parse_to_json(Sheets.get_id_from_link(SPREADSHEET_LINK))


if __name__ == "__main__":
    main()
