FROM tomcat:9.0-jdk17-temurin
RUN rm -rf /usr/local/tomcat/webapps/*
COPY target/pet-adoption.war /usr/local/tomcat/webapps/pet-adoption.war
EXPOSE 8080
CMD ["catalina.sh", "run"]