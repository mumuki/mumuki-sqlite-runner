#!/bin/sh

FILE="$1"

python runmql.py ${FILE} 2>&1
exit $?
