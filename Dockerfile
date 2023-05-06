FROM openjdk:8-jdk-alpine
COPY target/*.war app.war
ENTRYPOINT ["java","-war","/app.war"]

