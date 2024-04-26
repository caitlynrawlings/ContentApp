import os

from .constants import (
    VALID_CONTENT_TYPES, UPDATE_DIR
)
from .drive import Drive


class Parser:
    @staticmethod
    def parse(languages, row, title):
        content_type = row[0]
        if content_type not in VALID_CONTENT_TYPES:
            raise Exception(f"Type {content_type} not parseable")

        parser_method = getattr(Parser, f"_parse_{content_type.lower()}", None)
        if parser_method is None or not callable(parser_method):
            raise Exception(f"No parser defined for {content_type}")

        return {
            "content-type": content_type,
            "content": {
                languages[i]: parser_method(row[2:], i, languages[i], title)
                for i in range(len(languages))
            }
        }

    @staticmethod
    def _parse_text(cell, i, _, __):
        if i >= len(cell):
            return ""
        return cell[i]

    @staticmethod
    def _parse_heading(cell, i, _, __):
        if i >= len(cell):
            return ""
        return cell[i]

    @staticmethod
    def _parse_subheading(cell, i, _, __):
        if i >= len(cell):
            return ""
        return cell[i]

    @staticmethod
    def _parse_image(cell, i, language, title):
        if i >= len(cell):
            return {
                "path": "",
                "alt": "",
                "caption": ""
            }

        cell = cell[i]
        newlines = cell.split('\n')
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "alt": newlines[1].strip(),
            "caption": newlines[2].strip() if len(newlines) > 2 else ""
        }

    @staticmethod
    def _parse_spacer(cell, i, _, __):
        if i >= len(cell):
            return ""

        return int(cell[i])

    @staticmethod
    def _parse_iconsubheading(cell, i, language, title):
        if i >= len(cell):
            return {
                "path": "",
                "subheading": ""
            }

        cell = cell[i]
        newlines = cell.split('\n')
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "subheading": newlines[1].strip()
        }

    @staticmethod
    def _parse_callout(cell, i, language, title):
        if i >= len(cell):
            return {
                "path": "",
                "text": ""
            }

        cell = cell[i]
        newlines = cell.split('\n')
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "text": newlines[1].strip()
        }

    @staticmethod
    def _parse_audio(cell, i, language, title):
        if i >= len(cell):
            return {
                "path": "",
                "caption": ""
            }

        cell = cell[i]
        newlines = cell.split('\n', 1)
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path" : file_name,
            "caption" : newlines[1].strip()
        }

    @staticmethod
    def _parse_toggle(cell, i, _, __):
        if i >= len(cell):
            return {
                "title": "",
                "body": ""
            }

        cell = cell[i]
        newlines = cell.split('\n', 1)

        return {
            "title": newlines[0],
            "body" : newlines[1].strip()
        }

    @staticmethod
    def _parse_link(cell, i, _, __):
        if i >= len(cell):
            return {
                "displayText": "",
                "page": ""
            }

        cell = cell[i]
        newlines = cell.split('\n')

        return {
            "displayText" : newlines[0],
            "page" : newlines[1]
        }

    @staticmethod
    def __download_file(link, language, title):
        name = Drive.get_file_name(link=link)
        file_name = f"{title}-{language}-{name}"
        path = os.path.join(UPDATE_DIR, file_name)
        Drive.download_file_link(link, path)

        return file_name
