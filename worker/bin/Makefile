PY=python
DIFF=diff --ignore-blank-lines --ignore-trailing-space

.PHONY: all clean pytest

all: clean pytest

pytest:
	$(PY) runmql.py test/INPUT.sql > test/OUTPUT.json
	$(DIFF) test/EXPECTED.json test/OUTPUT.json

clean:
	rm -f *.pyc mumuki test/OUTPUT.json
