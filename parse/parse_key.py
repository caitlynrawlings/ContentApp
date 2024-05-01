import json


def main():
    key = {}    # TODO: Paste service account JSON key here

    print('"' + json.dumps(key).replace('\\', r'\\').replace('"', r'\"') + '"')


if __name__ == "__main__":
    main()