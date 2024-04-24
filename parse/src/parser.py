import os

from .exceptions import ImproperFormat
from .constants import (
    VALID_CONTENT_TYPES, UPDATE_DIR
)
from .drive import Drive


class Parser:
    @staticmethod
    def parse(languages, row, title):
        content_type = row[0]
        if content_type not in VALID_CONTENT_TYPES:
            raise ImproperFormat(f"Type {content_type} not parseable")

        parser_method = getattr(Parser, f"_parse_{content_type.lower()}", None)
        if parser_method is None or not callable(parser_method):
            raise Exception(f"No parser defined for {content_type}")

        return {
            "content-type": content_type,
            "content": {
                languages[i]: parser_method(row[1:][i], languages[i], title, i) if i < len(row[1:]) else ""
                for i in range(len(languages))
            }
        }

    @staticmethod
    def _parse_text(cell, _, __, ___):
        return cell

    @staticmethod
    def _parse_heading(cell, _, __, ___):
        return cell

    @staticmethod
    def _parse_subheading(cell, _, __, ___):
        return cell

    @staticmethod
    def _parse_image(cell, language, title, i):
        newlines = cell.split('\n')
        name = Drive.get_file_name(link=newlines[0])
        file_name = f"{title}-{i}-{language}-{name}"
        path = os.path.join(UPDATE_DIR, file_name)

        Drive.download_file_link(newlines[0], path)
        return {
            "path": file_name,
            "alt": newlines[1].strip(),
            "caption": newlines[2].strip() if len(newlines) > 2 else ""
        }

    @staticmethod
    def _parse_spacer(cell, _, __, ___):
        return cell

    @staticmethod
    def _parse_iconsubheading(cell, _, __, ___):
        newlines = cell.split('\n')
        name = Drive.get_file_name(link=newlines[0])
        path = os.path.join(UPDATE_DIR, name)

        Drive.download_file_link(newlines[0], path)
        return {
            "path": name,
            "subheading": newlines[1].strip()
        }

    @staticmethod
    def _parse_callout(cell, _, __, ___):
        newlines = cell.split('\n')
        name = Drive.get_file_name(link=newlines[0])
        path = os.path.join(UPDATE_DIR, name)

        Drive.download_file_link(newlines[0], path)
        return {
            "path": name,
            "text": newlines[1].strip()
        }
