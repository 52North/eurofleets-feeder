FROM adoptopenjdk/openjdk8:alpine-slim AS BCRYPT_BUILDER

WORKDIR /app
COPY BCrypt.java /app
RUN javac -source 1.8 -target 1.8 BCrypt.java \
 && rm BCrypt.java

FROM 52north/sos:5.0.1

USER root
COPY --from=BCRYPT_BUILDER /app /usr/lib/java-brcypt
COPY bcrypt.sh /usr/local/bin/bcrypt
COPY sos-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/sos-entrypoint.sh \
             /usr/local/bin/bcrypt

USER jetty:jetty

ENTRYPOINT [ \
  "/usr/local/bin/sos-entrypoint.sh", \
  "/usr/local/bin/faroe-entrypoint.sh", \
  "/docker-entrypoint.sh" ]

