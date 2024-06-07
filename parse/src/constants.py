import os

# Spreadsheet
SPREADSHEET_LINK = "https://docs.google.com/spreadsheets/d/1tu5G4pl6Wn2uOx3CbrUiJHEZy2e_8F2bPn8Ry6HJYJ4/edit?usp=sharing"

# Directories & Files
STORAGE_DIR = os.path.join(os.getcwd(), 'assets')
DOWNLOADS_DIR = os.path.join(STORAGE_DIR, 'downloads')
UPDATE_DIR = os.path.join(STORAGE_DIR, 'update')

# TODO: Update to use environment variable
ENVIRONMENT_API_KEY = "SHEETS_API"
PARSED_JSON = os.path.join(STORAGE_DIR, "pages.json")

# Sheets stuff
ALT_CONTENT = {"Image"}
DOWNLOADABLE = {"Video"}.union(ALT_CONTENT)
VALID_CONTENT_TYPES = {"Text", "Heading", "Subheading", "IconSubheading",
                       "Callout", "Spacer", "Audio", "Toggle", "Link", "ImageText"}.union(DOWNLOADABLE)

SKIPPED_SHEETS = {"Languages", "Base", "Demo"}
MAX_ROWS = 1000
