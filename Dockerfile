FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /src

COPY pom.xml .
RUN mvn -B -q dependency:go-offline

COPY src ./src
RUN mvn -B -q package -DskipTests


FROM eclipse-temurin:21.0.12_8-jre

RUN useradd --system --uid 1001 --create-home appuser
WORKDIR /app
COPY --from=build --chown=1001:1001 /src/target/*.jar app.jar
USER 1001
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]