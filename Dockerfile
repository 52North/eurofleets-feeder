FROM adoptopenjdk/openjdk8:latest AS BUILDER

WORKDIR /app
COPY .mvn ./.mvn
COPY mvnw ./mvnw
COPY pom.xml ./
RUN ./mvnw clean install -Dspring-boot.repackage.skip=true

COPY ./ ./
RUN ./mvnw clean install

FROM adoptopenjdk/openjdk8:latest
COPY --from=BUILDER /app/target/eurofleets-feeder-0.0.1-SNAPSHOT.jar /app.jar
CMD [ "java", "-jar", "/app.jar", "--debug" ]