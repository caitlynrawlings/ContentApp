import pytest
from src.parser import Parser

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
    _test_basic("Text", languages, row, expected)
    _test_basic("Heading", languages, row, expected)
    _test_basic("Subheading", languages, row, expected)


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
    _test_two_line("Toggle", ['title', 'body'], languages, row, expected)
    _test_two_line("Link", ['displayText', 'page'], languages, row, expected)


@pytest.mark.parametrize(*bad_two_line_args)
def test_bad_two_line(languages, row):
    _test_invalid("Toggle", languages, row)
    _test_invalid("Link", languages, row)


# ------------------------------------- #
# TODO: Additional methods w/ API calls #
# ------------------------------------- #
def test_image():
    # TODO: Need to mock google api calls :)
    pass


def test_icon_subheading():
    # TODO: Need to mock google api calls :)
    pass


def test_callout():
    # TODO: Need to mock google api calls :)
    pass


def test_audio():
    # TODO: Need to mock google api calls :)
    pass


# -------------- #
# Helper methods #
# -------------- #
def _test_two_line(type, keys, languages, row, expected):
    _replace_sub_keys(expected, languages, ['a', 'b'], keys)
    _test_basic(type, languages, row, expected)
    _replace_sub_keys(expected, languages, keys, ['a', 'b'])


def _replace_sub_keys(dict, keys, olds, news):
    for key in keys:
        for i in range(len(olds)):
            dict[key][news[i]] = dict[key].pop(olds[i])


def _test_invalid(type, languages, row):
    row.insert(0, type)
    with pytest.raises(Exception):
        Parser.parse(languages, row, 0, '')
    row.pop(0)


def _test_basic(type, languages, row, expected):
    row.insert(0, type)
    assert Parser.parse(languages, row, 0, '') == {
        'content-type': type,
        'content': expected
    }
    row.pop(0)
