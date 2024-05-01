# Content App
## Setup
#### Google API
In order to interface properly with the necessary Google APIs, you'll have to create a service account. Below are steps detailing how to do so:

1. Create a [new project](https://console.cloud.google.com/projectcreate) in the Google Cloud Dashboard
2. Go to the [API dashboard](https://console.cloud.google.com/apis/dashboard) page
3. Enable the Google Sheet and Google Drive APIs within your project 
4. Go to the [service accounts](https://console.cloud.google.com/iam-admin/serviceaccounts) page within IAM
5. Click "Create Service Account" and fill in required fields (note down the service account email address).
6. Click [...] > Manage Keys > Add Key > Create New Key > JSON > Create
7. Copy the downloaded JSON key into the `parse/parse_key.py` script and run it locally (be sure to delete your key after so it's not propagated into the repo)
8. Copy the output of the script in paste it into a Github Actions Repository secret named `SHEETS_API_TOKEN` (Settings > Secrets and variables > Actions > Repository Secrets > New Repository Secret)
9. Share the folder containing all necessary files (main sheet and linked downloadables) with the service account email address

#### Github
To see local changes before deploying you'll also have to enable Github Pages for the respository. To do so:

1. Settings > Pages > Deploy From A Branch > `preview` / `root`

#### Google Sheet
The last setup step involves creating a new Google Sheet for your project based off of the [provided example](https://docs.google.com/spreadsheets/d/1tu5G4pl6Wn2uOx3CbrUiJHEZy2e_8F2bPn8Ry6HJYJ4/edit?usp=sharing) and changing the `spreadsheet_link` variable within `parse/main.py` to link there instead.

## Frontend

TODO: Description

## Backend
In this project, the backend scripts pull updates from the main google sheet, and converts the data there into a format useable by the frontend team in rendering. This involves interfacing with the [Google Sheets API](https://developers.google.com/sheets/api/guides/values) to read cell data.

As users are allowed to link additional files (images, audio, icon, etc.) within the sheet itself, it's also necessary for these scripts to use the [Google Drive API](https://developers.google.com/drive/api/guides/manage-downloads) to download files from the users google drive. So long as the files are shared with the necessary service account (mentioned above)

#### Development
To work on developing the parser, you'll first have to download [python](https://www.python.org/downloads/), [conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html), and [pip](https://pip.pypa.io/en/stable/cli/pip_download/). Then, run the following commands:

```bash
conda create --name content-app
conda activate content-app
pip install -r parse/requirements.txt
```

You'll also have to create an [environment variable](https://developer.vonage.com/en/blog/python-environment-variables-a-primer) named `SHEETS_API_TOKEN` containing the [previously mentioned](#google-api) parsed key.

If you wish to add additional content types, you'll have to add a `_parse_{TYPE}` function within `parse/src/parser.py` file. Note that this function will take in a single cell of data and should return the appropriate JSON format for that cell. Examples can be seen already implemented within the `parser.py` file.

Additionally, you'll have to update the `VALID_CONTENT_TYPES` variable within `parse/src/constants.py` such that the script recognizes the content type as parseable and valid.

Lastly, we'd recommend adding tests to `parse/test/test_parser.py` to verify that your implemented parsing function works properly before pushing to the repository. This step is not required but highly encouraged.

## Directory Structure
Below are files of note for those that wish to continue development on this project
### Frontend
TODO
- assets
    - downloads - Where necessary files (images, audio, icon, etc.) will be placed to be used in rendering the frontend
    - pages.json - The intermediary .json file created by the backend and read by the frontend to display
    - example.json - An example .json file containing all possible data types used for testing purposes
### Backend
- parse
    - src
        - constants.py - Where a number of constants used by the parsing scripts are located. Importantly, if you want to add additional content types, you'll have to add them here.
        - drive.py - Class that interfaces with the google drive api. Used to download necessary files linked in the main sheet (images, audio, icon, etc.).
        - parser.py - Handles parsing a single row from the google sheet into the proper .json object. When adding additional content types, define a parse function within this file.
        - sheets.py - Class that interfaces with the google sheets api. Used to download cell information from the main sheet.
    - test
        - test_parser.py - Tests to make sure that each parse function converts a row of data into a properly formatted .json object.
    - main.py - Houses the main script that's run to convert the main sheet into json useable by the frontend

