FROM tcgerlach/sqlite
MAINTAINER Leandro Di Lorenzo <leandro.jdl@gmail.com>

COPY runsql /bin/runsql
RUN chmod u+x /bin/runsql

COPY 0_create_table.sql /db.sql
RUN runsql db.sql

ENTRYPOINT [""]
CMD ["/bin/sh"]
