CXX=g++
FLAGS=-Wall -std=c++11
DIFF=diff --ignore-blank-lines
#FLAGS=-lm -lcrypt -O2 -std=c++11 -pipe -DONLINE_JUDGE

all: clean pytest

mqlsplit: mqlsplit.cpp
	$(CXX) $(FLAGS) $^ -o $@

test:
	./mqlsplit test.sql
	$(DIFF) mql_create.expect     mql_create.sql
	$(DIFF) mql_inserts.expect    mql_inserts.sql
	$(DIFF) mql_select-doc.expect mql_select-doc.sql
	$(DIFF) mql_select-alu.expect mql_select-alu.sql

pytest:
	python mqlsplit.py test.sql
	$(DIFF) mql_create.expect     mql_create.sql
	$(DIFF) mql_inserts.expect    mql_inserts.sql
	$(DIFF) mql_select-doc.expect mql_select-doc.sql
	$(DIFF) mql_select-alu.expect mql_select-alu.sql


clean:
	rm -f mqlsplit mql_*.sql .trash
