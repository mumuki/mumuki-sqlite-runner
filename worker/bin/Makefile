CXX=g++
PY=python
CFLAGS=-Wall -std=c++11
DIFF=diff --ignore-blank-lines

.PHONY: all clean runsql test pytest diff

all: clean runsql

mqlsplit: mqlsplit.cpp
	$(CXX) $(CFLAGS) $^ -o $@

test:
	./mqlsplit test.sql

pytest:
	$(PY) mqlsplit.py test.sql

runsql:
	./runsql test.sql
	$(DIFF) sqlite_output.expect sqlite_output.txt

diff:
	$(DIFF) mql_create.expect     mql_create.sql
	$(DIFF) mql_inserts.expect    mql_inserts.sql
	$(DIFF) mql_select-doc.expect mql_select-doc.sql
	$(DIFF) mql_select-alu.expect mql_select-alu.sql

clean:
	rm -f mqlsplit mql_*.sql .trash sqlite_output.txt mumuki
