FROM tcgerlach/sqlite
MAINTAINER Leandro Di Lorenzo <leandro.jdl@gmail.com>

RUN apk add --update python

COPY sqliterc /root/.sqliterc
COPY split/runsql /bin/runsql
COPY split/mqlsplit.py /bin/mqlsplit.py

# temporary copy file to testing mqlsplit
COPY split/test.sql /mqlsplit_test.sql

RUN chmod u+x /bin/runsql
RUN chmod u+x /bin/mqlsplit.py

ENTRYPOINT [""]
CMD ["/bin/sh"]
