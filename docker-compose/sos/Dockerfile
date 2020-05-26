FROM 52north/sos:5

ENV HELGOLAND_CONFIG=${HELGOLAND}/assets/settings.json \ 
    SOS_CONTEXT_PATH=

USER root

RUN apk add --no-cache gettext

COPY extended-sos-entrypoint.sh /usr/local/bin/

COPY jetty-web.xml ${WEBAPP}/WEB-INF/jetty-web.xml.template

USER jetty:jetty

HEALTHCHECK --start-period=60s --interval=30s \
            --timeout=20s --retries=3 \
  CMD wget http://localhost:8080${SOS_CONTEXT_PATH} -q -O - > /dev/null 2>&1


ENTRYPOINT [ \
  "/usr/local/bin/extended-sos-entrypoint.sh", \
  "/usr/local/bin/sos-entrypoint.sh", \
  "/usr/local/bin/faroe-entrypoint.sh", \
  "/docker-entrypoint.sh" ]

CMD [ "java", "-jar", "/usr/local/jetty/start.jar" ]