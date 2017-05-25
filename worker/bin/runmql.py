#!/usr/bin/python

from sys import argv
from mql import MQL
from mqlparser import MQLParser


args_error = """
Error: file needed as argument.
Example: python mql.py INPUT.sql
"""


if __name__ == '__main__':

    if len(argv) <= 1:
        print args_error
        exit(1)

    with open(argv[1]) as f:
        parser = MQLParser(f.readlines())

    parser.compile()

    if parser.has_error():
        print parser.error()
        exit(1)

    # # temp until MQL is ready
    # print parser.get_code()

    mql = MQL(parser.get_code())
    mql.run()

    if mql.has_error():
        print mql.error()
        exit(1)

    print mql.get_result()
