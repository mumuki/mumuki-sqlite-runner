SHELL=sh
DIFF=diff --ignore-blank-lines --ignore-trailing-space

.PHONY: all clean test test_error

.IGNORE: test_error

all: clean test test_error

test:
	python test/testmql.py
	$(SHELL) runsql.sh test/INPUT.json > test/OUTPUT.json
	$(DIFF) test/EXPECTED.json test/OUTPUT.json

test_error:
	$(SHELL) runsql.sh test/INPUT_ERROR.json > test/OUTPUT_ERROR.json
	$(DIFF) test/EXPECTED_ERROR.json test/OUTPUT_ERROR.json

clean:
	rm -f *.pyc mumuki.sqlite test/OUTPUT.json test/OUTPUT_ERROR.json
