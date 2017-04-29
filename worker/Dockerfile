FROM tcgerlach/sqlite
MAINTAINER Leandro Di Lorenzo <leandro.jdl@gmail.com>

RUN apk add --update python

COPY config/sqliterc /root/.sqliterc
COPY bin/runsql /bin/runsql
COPY bin/mqlsplit.py /bin/mqlsplit.py

# temporary copy file to testing mqlsplit
COPY bin/test.sql /mqlsplit_test.sql

RUN chmod u+x /bin/runsql
RUN chmod u+x /bin/mqlsplit.py

ENTRYPOINT [""]
CMD ["/bin/sh"]
