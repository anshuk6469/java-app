# Stage 1: Build the Spring Boot application
FROM adoptopenjdk/openjdk17:alpine as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper and project descriptor files
COPY mvnw .
COPY .mvn .mvn

# Copy the project files
COPY pom.xml .
COPY src src

# Build the application
RUN ./mvnw package -DskipTests

# Stage 2: Create the Docker image
FROM adoptopenjdk/openjdk17:alpine-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged Spring Boot application JAR file from the previous stage
COPY --from=builder /app/target/demo.jar /app/demo.jar

# Expose the port on which the Spring Boot application will run
EXPOSE 8080

# Define environment variables (optional)
ENV ENVIRONMENT=production
ENV DATABASE_URL=jdbc:mysql://localhost:3306/db_name

# Specify any volume for persistence (optional)
VOLUME /app/data

# Run the Spring Boot application when the container starts
CMD ["java", "-jar", "demo.jar"]