FROM postgres:9.6.2
MAINTAINER Leandro Di Lorenzo

ENV POSTGRES_DB=mumuki
ENV POSTGRES_USER=mumuki
ENV POSTGRES_PASSWORD=mumuki

COPY 0_create_table.sql /docker-entrypoint-initdb.d/
COPY 1_init.sh /docker-entrypoint-initdb.d/

EXPOSE 5432
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
