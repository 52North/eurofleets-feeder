FROM adoptopenjdk/openjdk8:alpine-slim AS BUILDER

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY mvnw pom.xml ./
COPY .mvn ./.mvn

RUN chmod +x ./mvnw && ./mvnw clean install -Dspring-boot.repackage.skip=true

COPY ./ ./

RUN chmod +x ./mvnw && ./mvnw clean install

FROM adoptopenjdk/openjdk8:alpine-slim

ARG VERSION=0.0.1-SNAPSHOT

COPY --from=BUILDER /app/target/eurofleets-feeder-${VERSION}.jar /app.jar

CMD [ "java", "-jar", "/app.jar" ]
