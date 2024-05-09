import pytest
from unittest.mock import patch
from src.parser import Parser

from src.drive import Drive

# ------------------------- #
# Simple text type elements #
# ------------------------- #
text_args = (
    'languages, row, expected', [
        (['one'], ['example', 'a'], {'one': 'a'}),
        (['one', 'two'], ['example', 'a', 'b'], {'one': 'a', 'two': 'b'}),
        (['one', 'two', 'three'], ['example', 'a', 'b', 'c'], {'one': 'a', 'two': 'b', 'three': 'c'}),
    ]
)
bad_text_args = (
    'languages, row', [
        (['one'], ['example']),
        (['one'], ['example', '']),
        (['one', 'two'], ['example']),
        (['one', 'two'], ['example', '']),
        (['one', 'two'], ['example', '', '']),
    ]
)


@pytest.mark.parametrize(*text_args)
def test_basic(languages, row, expected):
    _test_n_line("Text", 0, [], languages, row, expected)
    _test_n_line("Heading", 0, [], languages, row, expected)
    _test_n_line("Subheading", 0, [], languages, row, expected)


@pytest.mark.parametrize(*bad_text_args)
def test_basic_invalid(languages, row):
    _test_invalid("Text", languages, row)
    _test_invalid("Heading", languages, row)
    _test_invalid("Subheading", languages, row)


# -------------------------------------------- #
# Spacer element is special since we want ints #
# -------------------------------------------- #
number_args = (
    'languages, row, expected', [
        (['one'], ['example', '1'], {'one': 1}),
        (['one', 'two'], ['example', '1', '2'], {'one': 1, 'two': 2}),
        (['one', 'two', 'three'], ['example', '1', '2', '3'], {'one': 1, 'two': 2, 'three': 3}),
    ]
)
bad_number_args = (
    'languages, row', [
        (['one'], ['example']),
        (['one'], ['example', '']),
        (['one'], ['example', 'a']),
    ]
)


@pytest.mark.parametrize(*number_args)
def test_spacer(languages, row, expected):
    _test_basic("Spacer", languages, row, expected)


@pytest.mark.parametrize(*bad_number_args)
def test_spacer_invalid(languages, row):
    _test_invalid("Spacer", languages, row)


# -------------------------------- #
# Two-line text formatting options #
# -------------------------------- #
two_line_args = (
    'languages, row, expected', [
        (['one'], ['example', 't\nc'], {'one': {'a': 't', 'b': 'c'}}),
        (['one', 'two'], ['example', '1t\nc', '2t\nc'], {'one': {'a': '1t', 'b': 'c'}, 'two': {'a': '2t', 'b': 'c'}}),
        (['one', 'two', 'three'], ['example', 'o\na', 'tw\nb', 'th\nc'], {'one': {'a': 'o', 'b': 'a'}, 'two': {'a': 'tw', 'b': 'b'}, 'three': {'a': 'th', 'b': 'c'}}),
    ]
)
bad_two_line_args = (
    'languages, row', [
        (['one'], ['example']),
        (['one'], ['example', '']),
        (['one'], ['example', 'a']),
    ]
)


@pytest.mark.parametrize(*two_line_args)
def test_two_line(languages, row, expected):
    _test_n_line("Toggle", 2, ['title', 'body'], languages, row, expected)
    _test_n_line("Link", 2, ['displayText', 'page'], languages, row, expected)


@pytest.mark.parametrize(*two_line_args)
def test_two_line_downloads(languages, row, expected):
    _test_n_line("IconSubheading", 2, ['path', 'subheading'], languages, row, expected, "path")
    _test_n_line("Callout", 2, ['path', 'text'], languages, row, expected, "path")
    _test_n_line("Audio", 2, ['path', 'caption'], languages, row, expected, "path")


@pytest.mark.parametrize(*bad_two_line_args)
def test_bad_two_line(languages, row):
    _test_invalid("Toggle", languages, row)
    _test_invalid("Link", languages, row)
    _test_invalid("IconSubheading", languages, row)
    _test_invalid("Callout", languages, row)
    _test_invalid("Audio", languages, row)


# ---------------------------------- #
# Three-line text formatting options #
# ---------------------------------- #
three_line_args = (
    'languages, row, expected', [
        (['one'], ['example', '1\n2\n3'], {'one': {'a': '1', 'b': '2', 'c': '3'}}),
        (['one', 'two'], ['example', '1\n2\n3', '11\n22\n33'], {'one': {'a': '1', 'b': '2', 'c': '3'}, 'two': {'a': '11', 'b': '22', 'c': '33'}}),
    ]
)
bad_three_line_args = (
    'languages, row', [
        (['one'], ['example']),
        (['one'], ['example', '']),
        (['one'], ['example', '1']),
        (['one'], ['example', '1\n2']),
    ]
)


@pytest.mark.parametrize(*three_line_args)
def test_three_line_downloads(languages, row, expected):
    _test_n_line("Image", 3, ['path', 'alt', 'caption'], languages, row, expected, "path")


# -------------- #
# Helper methods #
# -------------- #
def _test_n_line(type, n, keys, languages, row, expected, download_key=None):
    _replace_sub_keys(expected, languages, [chr(ord('a') + i) for i in range(n)], keys)
    _test_basic(type, languages, row, expected if download_key is None else
                {key: {keyy: valuee if keyy != download_key else "image_name"
                       for keyy, valuee in value.items()}
                 for key, value in expected.items()})
    _replace_sub_keys(expected, languages, keys, [chr(ord('a') + i) for i in range(n)])


def _replace_sub_keys(dict, keys, olds, news):
    for key in keys:
        for i in range(len(olds)):
            dict[key][news[i]] = dict[key].pop(olds[i])


def _test_invalid(type, languages, row):
    row.insert(0, type)
    with pytest.raises(Exception):
        Parser.parse_row(languages, row, 0, '')
    row.pop(0)


def _test_basic(type, languages, row, expected):
    row.insert(0, type)
    assert Parser.parse_row(languages, row, 0, '') == {
        'content-type': type,
        'content': expected
    }
    row.pop(0)


# ------- #
# Mocking #
# ------- #
@pytest.fixture(autouse=True)
def mock_drive_methods():
    with patch.object(Drive, 'get_file_name', return_value="image_name") as m1, \
         patch.object(Drive, 'download_file_link', return_value=None) as m2:
        yield m1, m2
