FROM openjdk:8-jdk-alpine
COPY target/*.war app.war
EXPOSE 8088
ENTRYPOINT ["java","-jar","/app.war"]
