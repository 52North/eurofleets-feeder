FROM adoptopenjdk/openjdk8:alpine-slim AS BUILDER

RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY .mvn ./.mvn
COPY mvnw ./mvnw
COPY pom.xml ./
RUN ./mvnw clean install -Dspring-boot.repackage.skip=true

COPY ./ ./
RUN ./mvnw clean install

FROM adoptopenjdk/openjdk8:alpine-slim
COPY --from=BUILDER /app/target/eurofleets-feeder-0.0.1-SNAPSHOT.jar /app.jar
CMD [ "java", "-jar", "/app.jar" ]
