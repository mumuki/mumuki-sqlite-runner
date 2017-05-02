#!/bin/sh
FILE="$1"
ERROR="error.log"
OUTPUT="sqlite_output.txt"
SQL1="mql_create.sql"
SQL2="mql_inserts.sql"
SQL3="mql_select-doc.sql"
SQL4="mql_select-alu.sql"

# create files to prevent errors if not exists
touch ${ERROR}
touch ${SQL1}
touch ${SQL2}
touch ${SQL3}
touch ${SQL4}

# split input request
(mqlsplit.py ${FILE}) > /dev/null

# run each sql file
for i in `seq 1 4`; do
    eval SQL_FILE=\${SQL${i}}
    echo "-- ${SQL_FILE}" >> ${OUTPUT}
    (sqlite3 mumuki < ${SQL_FILE}) >> ${OUTPUT} 2>&1  # save stdout & stderr to the output-file to be sent back
    (sqlite3 mumuki_error < ${SQL_FILE}) 2>> ${ERROR} # save stderr into error-file to check for errors
done

## if error has no content, then exit success, else error
if [ $(tr -d "\r\n" < ${ERROR}|wc -c) -eq 0 ]; then
    CODE=0
else
    CODE=1
fi

(cat ${OUTPUT}) 2>&1
exit ${CODE}