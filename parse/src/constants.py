import os

# Directories & Files
STORAGE_DIR = os.path.join(os.getcwd(), 'assets')
DOWNLOADS_DIR = os.path.join(STORAGE_DIR, 'downloads')
UPDATE_DIR = os.path.join(STORAGE_DIR, 'update')

# TODO: Update to use environment variable
CREDENTIALS_FILE = os.path.join(STORAGE_DIR, 'credentials.json')
PARSED_JSON = os.path.join(STORAGE_DIR, "pages.json")

# Sheets stuff
ALT_CONTENT = {"Image"}
DOWNLOADABLE = {"Video"}.union(ALT_CONTENT)
VALID_CONTENT_TYPES = {"Text", "Heading", "Subheading"}.union(DOWNLOADABLE)

SKIPPED_SHEETS = {"Languages", "Base"}
MAX_ROWS = 1000
