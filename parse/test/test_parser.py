import pytest
from src.parser import Parser

standard_text_args = (
    'languages, row, expected', [
        (['one'], ['a'], {'one': 'a'}),
        (['one', 'two'], [], {'one': '', 'two': ''}),
        (['one', 'two'], ['a'], {'one': 'a', 'two': ''}),
        (['one', 'two'], ['a', 'b'], {'one': 'a', 'two': 'b'}),
        (['one', 'two', 'three'], ['', 'b', ''], {'one': '', 'two': 'b', 'three': ''}),
    ]
)


@pytest.mark.parametrize(*standard_text_args)
def test_text(languages, row, expected):
    _test_basic_text("Text", languages, row, expected)


@pytest.mark.parametrize(*standard_text_args)
def test_heading(languages, row, expected):
    _test_basic_text("Heading", languages, row, expected)


@pytest.mark.parametrize(*standard_text_args)
def test_subheading(languages, row, expected):
    _test_basic_text("Subheading", languages, row, expected)


def _test_basic_text(type, languages, row, expected):
    row.insert(0, type)
    assert Parser.parse(languages, row, '') == {
        'content-type': type,
        'content': expected
    }
    row.pop(0)


def test_image():
    pass
