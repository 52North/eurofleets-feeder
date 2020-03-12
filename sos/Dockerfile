FROM 52north/sos:latest

USER root

COPY sos-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/sos-entrypoint.sh

USER jetty:jetty

ENTRYPOINT [ \
  "/usr/local/bin/sos-entrypoint.sh", \
  "/usr/local/bin/faroe-entrypoint.sh", \
  "/docker-entrypoint.sh" ]

