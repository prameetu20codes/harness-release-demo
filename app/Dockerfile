# syntax=docker/dockerfile:1.7
# ---------- Stage 1: build ----------
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /workspace

# Cache dependencies first for fast incremental CI builds
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

COPY src ./src
RUN mvn -B -q clean package -DskipTests

# ---------- Stage 2: runtime ----------
# Distroless: no shell, no package manager, minimal CVE surface, runs as non-root.
FROM gcr.io/distroless/java17-debian12:nonroot AS runtime
WORKDIR /app

# Build-time metadata injected by the Harness CI pipeline (--build-arg APP_VERSION=<+pipeline.sequenceId>)
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

COPY --from=build /workspace/target/product-catalog.jar /app/product-catalog.jar

EXPOSE 8080
USER nonroot
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-jar", "/app/product-catalog.jar"]
