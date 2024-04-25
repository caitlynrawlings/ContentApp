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
                languages[i]: "" if i >= len(row[2:]) else
                              parser_method(row[2:][i], languages[i], title)
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
        newlines = cell.split('\n')
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "alt": newlines[1].strip(),
            "caption": newlines[2].strip() if len(newlines) > 2 else ""
        }

    @staticmethod
    def _parse_spacer(cell, _, __):
        return int(cell)

    @staticmethod
    def _parse_iconsubheading(cell, language, title):
        newlines = cell.split('\n')
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "subheading": newlines[1].strip()
        }

    @staticmethod
    def _parse_callout(cell, language, title):
        newlines = cell.split('\n')
        file_name = Parser.__download_file(newlines[0], language, title)

        return {
            "path": file_name,
            "text": newlines[1].strip()
        }

    @staticmethod
    def __download_file(link, language, title):
        name = Drive.get_file_name(link=link)
        file_name = f"{title}-{language}-{name}"
        path = os.path.join(UPDATE_DIR, file_name)
        Drive.download_file_link(link, path)

        return file_name
