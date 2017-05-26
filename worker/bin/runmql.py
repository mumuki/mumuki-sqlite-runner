#!/usr/bin/python

import json
from sys import argv
from mql import MQL

args_error = """
Error: file needed as argument.
Example: runmql.py INPUT.json
"""


def as_json(content):
    return json.dumps(content, indent=2)


if __name__ == '__main__':

    if len(argv) <= 1:
        print args_error
        exit(1)

    with open(argv[1]) as json_file:
        code_blocks = json.load(json_file)

    # print code_blocks

    mql = MQL(code_blocks).run()

    # print mql

    if mql.has_error():
        print as_json(mql.get_error())
        exit(1)

    print as_json(mql.get_result())
