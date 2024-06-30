# Use a multi-stage build to reduce the size of the final image
# Stage 1: Build the application
FROM gradle:7.5.1-jdk11 as builder
WORKDIR /app
COPY . /app
# Print Gradle version
RUN gradle --version
RUN gradle build --no-daemon --stacktrace --info

# Stage 2: Run the application
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]