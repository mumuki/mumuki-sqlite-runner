FROM tcgerlach/sqlite
MAINTAINER Leandro Di Lorenzo <leandro.jdl@gmail.com>

RUN apk add --update python

ENV LANG C.UTF-8
COPY config/sqliterc /root/.sqliterc
COPY bin/runsql.sh /bin/runsql
COPY bin/runmql.py /bin/runmql.py
COPY bin/mql.py /bin/mql.py

RUN chmod u+x /bin/runsql
RUN chmod u+x /bin/runmql.py

ENTRYPOINT [""]
CMD ["/bin/sh"]
