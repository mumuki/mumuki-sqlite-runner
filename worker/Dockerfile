FROM tcgerlach/sqlite
MAINTAINER Leandro Di Lorenzo <leandro.jdl@gmail.com>

COPY runsql /bin/runsql
COPY sqliterc /root/.sqliterc
COPY init_db.sql /db.sql

RUN chmod u+x /bin/runsql
RUN runsql db.sql

ENTRYPOINT [""]
CMD ["/bin/sh"]
