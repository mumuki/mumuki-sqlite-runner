FROM tcgerlach/sqlite
MAINTAINER Leandro Di Lorenzo <leandro.jdl@gmail.com>

RUN apk add --update python

COPY config/sqliterc /root/.sqliterc
COPY bin/runsql.sh /bin/runsql
COPY bin/runmql.py /bin/runmql.py
COPY bin/mql.py /bin/mql.py

# temporary copy for testing
COPY bin/test/INPUT.json /INPUT.json
COPY bin/test/INPUT_ERROR.json /INPUT_ERROR.json

RUN chmod u+x /bin/runsql
RUN chmod u+x /bin/runmql.py

ENTRYPOINT [""]
CMD ["/bin/sh"]
