#!/usr/bin/python

from sys import *

TAG = '-- '

def write_file(filename, buffer):
    file = open(filename, "w")
    file.write(buffer.strip() + "\n")
    file.close()

def get_filename(line):
    name = line.strip()
    name = name.replace(TAG, "")
    name = name.lower()
    return "mql_" + name + ".sql";

if __name__ == '__main__':

    if len(argv) <= 1:
        print "Error: file needed as argument."
        exit(1);

    # init vars
    buffer   = ''
    filename = ".trash"

    # read entire file
    with open(argv[1]) as file:
        content = file.readlines()

    # process file line by line
    for line in content:
        if line.startswith(TAG):
            # flush buffer into file & restart vars
            write_file(filename, buffer)
            buffer   = ''
            filename = get_filename(line)

        # buffer line
        buffer += line;

    # flush buffer into las file
    write_file(filename, buffer);
