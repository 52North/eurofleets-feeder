FROM mdillon/postgis:11-alpine
ENV POSTGRES_MULTIPLE_EXTENSIONS postgis
ADD schema.sql /docker-entrypoint-initdb.d/zz-00-schema.sql
ADD update_130_200.sql /docker-entrypoint-initdb.d/zz-01-update_130_200.sql