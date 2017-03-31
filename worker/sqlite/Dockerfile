FROM tcgerlach/sqlite
MAINTAINER Leandro Di Lorenzo <leandro.jdl@gmail.com>

COPY 0_create_table.sql /db.sql
RUN cat db.sql | sqlite3 mumuki

ENTRYPOINT ["sqlite3", "mumuki"]
