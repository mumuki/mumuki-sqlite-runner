#!/bin/sh

FILE="$1"

runmql.py ${FILE} 2>&1
exit $?
