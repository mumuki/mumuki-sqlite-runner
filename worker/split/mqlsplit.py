#!/usr/bin/python

import sys

TAG = '-- '
buffer = ''
block_name = ''
filename   = ".trash"

def write_file(filename, buffer):
    file = open(filename, "w")
    file.write(buffer.strip() + "\n")
    file.close()

if len(sys.argv) <= 1:
    print "Error: file needed as argument."
    sys.exit(1);

infile = sys.argv[1]

with open(infile) as f:
    content = f.readlines()

for line in content:
    if line.startswith(TAG):
        # flush buffer
        write_file(filename, buffer)

        # get new block name
        block_name = line.strip()
        block_name = block_name.replace(TAG, "")
        block_name = block_name.lower()

        # set new tmp vars
        filename = "mql_" + block_name + ".sql";
        buffer = '';

    # save line
    buffer += line;

# flush last block
write_file (filename, buffer);
