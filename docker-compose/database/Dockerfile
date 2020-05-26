FROM mdillon/postgis:11-alpine
ENV POSTGRES_MULTIPLE_EXTENSIONS postgis
ADD schema.sql /docker-entrypoint-initdb.d/schema.sql