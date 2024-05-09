import os
import json
import shutil

from .constants import (
    VALID_CONTENT_TYPES, UPDATE_DIR, SKIPPED_SHEETS, MAX_ROWS,
    PARSED_JSON, DOWNLOADS_DIR
)
from .drive import Drive
from .sheets import Sheets


class Parser:
    @staticmethod
    def parse_to_json(spreadsheet_link):
        """
        TODO
        """
        # 1. Get all sheets
        spreadsheet_id = Sheets.get_id_from_link(spreadsheet_link)
        sheets = Sheets.get_sheets(spreadsheet_id)
        if "Languages" not in sheets:
            raise Exception("Google Sheet misssing 'Languages' page")

        # 2. Get expected languages
        languages_page = Sheets.get_values(spreadsheet_id, "Languages!1:2")
        json_data = {
            "languages": [{
                "language": languages_page[0][i],
                "direction": (Parser.__get_acronym(languages_page[1][i])
                              if i < len(languages_page[1]) else "")
            } for i in range(len(languages_page[0]))],
            "pages": []
        }

        # 3. Get data and parse
        for sheet in sheets:
            if sheet in SKIPPED_SHEETS:
                continue

            data = Sheets.get_values(spreadsheet_id, f"{sheet}!1:{MAX_ROWS}")
            if data[0][2:] != languages_page[0]:
                raise Exception(f"Provided sheet [{sheet}] doesn't include all languages: {data[0][2:]} != {languages_page[0]}")

            # Make sure every page has a title in every language
            if len(data[1][2:]) != len(languages_page[0]):
                raise Exception(f"Provided sheet [{sheet}] doesn't include a title in all languages: {data[1][2:]} != {len(languages_page[0])} element(s)")

            json_data['pages'].append(
                Parser.__convert_page_data(data, sheet)
            )

        # 4. Save to file
        with open(PARSED_JSON, 'w') as f:
            json.dump(json_data, f, indent=4)

        # 5. Rename update to downloads
        shutil.rmtree(DOWNLOADS_DIR)
        os.rename(UPDATE_DIR, DOWNLOADS_DIR)

        # 6. Delete the update directory once everything is moved
        shutil.rmtree(UPDATE_DIR, ignore_errors=True)

    @staticmethod
    def __convert_page_data(data, title):
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
                Parser.parse_row(languages, data[2:][row_i], row_i, title)
                for row_i in range(len(data[2:]))
            ]
        }
        return page_info

    @staticmethod
    def __get_acronym(phrase):
        return ''.join([token[0] for token in phrase.split()]).lower()

    @staticmethod
    def parse_row(languages, row, row_i, title):
        content_type = row[0]
        if content_type not in VALID_CONTENT_TYPES:
            raise Exception(f"Type {content_type} not parseable")

        if len(row[2:]) < len(languages):
            raise Exception(f"Missing translation on row {row_i + 3} of {title}")

        def handle_parse(cell, language, title):
            parser_method = getattr(Parser, f"_parse_{content_type.lower()}", None)

            if parser_method is None or not callable(parser_method):
                raise Exception(f"No parser defined for {content_type}")

            if cell.strip() == "":
                raise Exception(f"Empty cell in row {row_i + 3} of {title}")

            return parser_method(cell, language, title)

        return {
            "content-type": content_type,
            "content": {
                languages[i]: handle_parse(row[2:][i], languages[i], title)
                for i in range(len(languages))
            }
        }

    @staticmethod
    def _parse_text(cell, _, __):
        return cell

    @staticmethod
    def _parse_heading(cell, _, __):
        return cell

    @staticmethod
    def _parse_subheading(cell, _, __):
        return cell

    @staticmethod
    def _parse_image(cell, language, title):
        if cell == "":
            return {
                "path": "",
                "alt": "",
                "caption": ""
            }

        newlines = cell.split('\n')
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "alt": newlines[1].strip(),
            "caption": newlines[2].strip() if len(newlines) > 2 else ""
        }

    @staticmethod
    def _parse_spacer(cell, _, __):
        if cell == "":
            return ""

        return int(cell)

    @staticmethod
    def _parse_iconsubheading(cell, language, title):
        if cell == "":
            return {
                "path": "",
                "subheading": ""
            }

        newlines = cell.split('\n')
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "subheading": newlines[1].strip()
        }

    @staticmethod
    def _parse_callout(cell, language, title):
        if cell == "":
            return {
                "path": "",
                "text": ""
            }

        newlines = cell.split('\n')
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "text": newlines[1].strip()
        }

    @staticmethod
    def _parse_audio(cell, language, title):
        if cell == "":
            return {
                "path": "",
                "caption": ""
            }

        newlines = cell.split('\n', 1)
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "caption": newlines[1].strip()
        }

    @staticmethod
    def _parse_toggle(cell, _, __):
        if cell == "":
            return {
                "title": "",
                "body": ""
            }

        newlines = cell.split('\n', 1)

        return {
            "title": newlines[0],
            "body": newlines[1].strip()
        }

    @staticmethod
    def _parse_link(cell, _, __):
        if cell == "":
            return {
                "displayText": "",
                "page": ""
            }

        newlines = cell.split('\n')

        return {
            "displayText": newlines[0],
            "page": newlines[1]
        }

    @staticmethod
    def __download_file(link, language, title):
        file_name = Drive.get_file_name(link=link)

        # Uncomment if you want unique per-page/language naming:
        # file_name = f"{title}-{language}-{name}"

        path = os.path.join(UPDATE_DIR, file_name)
        Drive.download_file_link(link, path)

        return file_name
