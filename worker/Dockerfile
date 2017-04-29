FROM tcgerlach/sqlite
MAINTAINER Leandro Di Lorenzo <leandro.jdl@gmail.com>

RUN apk add --update python

COPY runsql /bin/runsql
COPY sqliterc /root/.sqliterc
COPY split/mqlsplit.py /bin/mqlsplit.py

# copy files to testing mqlsplit
COPY split/test.sql /mqlsplit_test.sql

RUN chmod u+x /bin/runsql
RUN chmod u+x /bin/mqlsplit.py

ENTRYPOINT [""]
CMD ["/bin/sh"]
