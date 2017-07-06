FILENAME=informe

.PHONY: all clean test test_error

compile:
	latexmk -pvc -pdf $(FILENAME).tex -shell-escape

publish:
	cp $(FILENAME).pdf ~/InformeTIP-DiLorenzo-RunnerSQLiteMumuki.pdf

clean:
	rm -f *.pyc *.aux *.fdb_latexmk *.fls *.log *.nav *.out *.snm *.toc
