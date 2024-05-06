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
Github is used to store the code, update changes to the app's content, and preview changes. To use it in these ways complete all the following steps:

1. Fork this repo
2. Ensure all the following branches exist
    - main: code that is ready to be deployed to the app. Updated when the "Save Current Changes and Deploy" workflow is ran
    - preview: updated when the "Sync Google Sheet Page Info" workflow is ran. Changes to this branch will be reflected in the github pages site
    - gh-pages: contains the necesary files to deploy what the app would look like to the github pages site. Updated when preview is updated
3. To see local changes before deploying you'll also have to enable Github Pages for the respository. To do so:
   Settings > Pages > Set "Source" to `Deploy From A Branch` > Set "Branch" to `gh-pages` / `root` > Save

#### Google Sheet
The last setup step involves creating a new Google Sheet for your project based off of the [provided example](https://docs.google.com/spreadsheets/d/1tu5G4pl6Wn2uOx3CbrUiJHEZy2e_8F2bPn8Ry6HJYJ4/edit?usp=sharing) and changing the `spreadsheet_link` variable within `parse/main.py` to link there instead.

## Frontend
The frontend reads from the intermediate pages.json file and sets states within the AppScreen class that store the data for languages, pages, and page content which is rendered in a [Flutter app](https://flutter.dev/). Languages are all added to the LanguageDropdown widget. The page titles are rendered in the selected language each as a bu. tton on the menu page. When a custom page is supposed to be displayed, the page contents are passed to the CustomPage widget where each of the peices of content are stacked in a column on the screen. 

## Backend
In this project, the backend scripts pull updates from the main google sheet, and converts the data there into a format useable by the frontend team in rendering. This involves interfacing with the [Google Sheets API](https://developers.google.com/sheets/api/guides/values) to read cell data.

As users are allowed to link additional files (images, audio, icon, etc.) within the sheet itself, it's also necessary for these scripts to use the [Google Drive API](https://developers.google.com/drive/api/guides/manage-downloads) to download files from the users google drive. So long as the files are shared with the necessary service account (mentioned above)

## Development
To work on developing the parser, you'll first have to download [python](https://www.python.org/downloads/), [conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html), and [pip](https://pip.pypa.io/en/stable/cli/pip_download/). Then, run the following commands:

```bash
conda create --name content-app
conda activate content-app
pip install -r parse/requirements.txt
```

You'll also have to create an [environment variable](https://developer.vonage.com/en/blog/python-environment-variables-a-primer) named `SHEETS_API_TOKEN` containing the [previously mentioned](#google-api) parsed key.

If you wish to add additional content types, you'll have to add a `_parse_{TYPE}` function within `parse/src/parser.py` file. Note that this function will take in a single cell of data and should return the appropriate JSON format for that cell. Examples can be seen already implemented within the `parser.py` file.

Additionally, you'll have to update the `VALID_CONTENT_TYPES` variable within `parse/src/constants.py` such that the script recognizes the content type as parseable and valid.

We'd recommend adding tests to `parse/test/test_parser.py` to verify that your implemented parsing function works properly before pushing to the repository. This step is not required but highly encouraged.

To implement the content type on the frontend define a widget in the `lib/content_types` directory and add a case to the switch statement in `custom_page.dart` that calls the widget you defined for that content type.

To run the app locally run the command in the top level of the repo:
```
flutter run
```
The file read from defaults to `assets/pages.json`. To use a different file to load app data from use:
```
flutter run --dart-define="FILE=<the file you want to load>"
```

## Directory Structure
Below are files of note for those that wish to continue development on this project
### Frontend
- assets
    - downloads - Where necessary files (images, audio, icon, etc.) will be placed to be used in rendering the frontend
    - pages.json - The intermediary .json file created by the backend and read by the frontend to display
    - example.json - An example .json file containing all possible data types used for testing purposes
- lib
    - content_types - Where widgets for each content type are defined
    - custom_page.dart - Class that returns a widget with the content for a custom page rendered
    - lang_dropdown.dart - The widget for the dropdown menu from which the language is selected
    - main.dart - Runs the Flutter app, parses the json file for languages and page data, displays app bar, tracks selected language, and handles rendering new page on page changes
    - menu.dart - The menu screen that displays the pages as buttons that can be navigated to
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

