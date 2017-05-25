#!/usr/bin/python

import json
from sys import argv
from mql import MQL
from mqlparser import MQLParser

args_error = """
Error: file needed as argument.
Example: python mql.py INPUT.sql
"""


def as_json(content):
    return json.dumps(content, indent=2)


if __name__ == '__main__':

    if len(argv) <= 1:
        print args_error
        exit(1)

    with open(argv[1]) as f:
        parser = MQLParser(f.readlines())

    parser.compile()

    if parser.has_error():
        print as_json(parser.error())
        exit(1)

    mql = MQL(parser.get_code())
    mql.run()

    if mql.has_error():
        print as_json(mql.error())
        exit(1)

    print as_json(mql.get_result())
