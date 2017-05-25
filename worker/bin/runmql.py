#!/usr/bin/python

from sys import argv
from mql import MQLParser


args_error = """
Error: file needed as argument.
Example: python mql.py test.sql
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

    print parser.get_code()

    # result = MQL(parser.get_code()).run()
    #
    # if result.has_error():
    #     print result.error()
    #     exit(1)
    #
    # print result.parse_output()
