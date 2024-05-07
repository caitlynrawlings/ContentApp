import pytest
from src.parser import Parser

standard_text_args = (
    'languages, row, expected', [
        (['one'], ['example', 'a'], {'one': 'a'}),
        (['one', 'two'], ['example', 'a', 'b'], {'one': 'a', 'two': 'b'}),
        (['one', 'two', 'three'], ['example', 'a', 'b', 'c'], {'one': 'a', 'two': 'b', 'three': 'c'}),
    ]
)


@pytest.mark.parametrize(*standard_text_args)
def test_text(languages, row, expected):
    _test_basic("Text", languages, row, expected)


@pytest.mark.parametrize(*standard_text_args)
def test_heading(languages, row, expected):
    _test_basic("Heading", languages, row, expected)


@pytest.mark.parametrize(*standard_text_args)
def test_subheading(languages, row, expected):
    _test_basic("Subheading", languages, row, expected)


def _test_basic(type, languages, row, expected):
    row.insert(0, type)
    assert Parser.parse(languages, row, 0, '') == {
        'content-type': type,
        'content': expected
    }
    row.pop(0)


def test_image():
    # TODO: Need to mock google api calls :)
    pass


def test_icon_subheading():
    # TODO: Need to mock google api calls :)
    pass


@pytest.mark.parametrize(
    'languages, row, expected', [
        (['one'], ['example', '1'], {'one': 1}),
        (['one', 'two'], ['example', '1', '2'], {'one': 1, 'two': 2}),
        (['one', 'two', 'three'], ['example', '1', '2', '3'], {'one': 1, 'two': 2, 'three': 3}),
    ]
)
def test_spacer(languages, row, expected):
    _test_basic("Spacer", languages, row, expected)


def test_callout():
    # TODO: Need to mock google api calls :)
    pass


def test_audio():
    # TODO: Need to mock google api calls :)
    pass


standard_two_line_args = (
    'languages, row, expected', [
        (['one'], ['example', 't\nc'], {'one': {'a': 't', 'b': 'c'}}),
        (['one', 'two'], ['example', '1t\nc', '2t\nc'], {'one': {'a': '1t', 'b': 'c'}, 'two': {'a': '2t', 'b': 'c'}}),
        (['one', 'two', 'three'], ['example', 'o\na', 'tw\nb', 'th\nc'], {'one': {'a': 'o', 'b': 'a'}, 'two': {'a': 'tw', 'b': 'b'}, 'three': {'a': 'th', 'b': 'c'}}),
    ]
)


@pytest.mark.parametrize(*standard_two_line_args)
def test_toggle(languages, row, expected):
    _replace_sub_keys(expected, languages, ['a', 'b'], ['title', 'body'])
    _test_basic("Toggle", languages, row, expected)
    _replace_sub_keys(expected, languages, ['title', 'body'], ['a', 'b'])


@pytest.mark.parametrize(*standard_two_line_args)
def test_link(languages, row, expected):
    _replace_sub_keys(expected, languages, ['a', 'b'], ['displayText', 'page'])
    _test_basic("Link", languages, row, expected)
    _replace_sub_keys(expected, languages, ['displayText', 'page'], ['a', 'b'])


def _replace_sub_keys(dict, keys, olds, news):
    for key in keys:
        for i in range(len(olds)):
            dict[key][news[i]] = dict[key].pop(olds[i])