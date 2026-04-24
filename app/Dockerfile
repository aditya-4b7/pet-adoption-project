FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

RUN apt-get update \
    && apt-get install -y curl unzip \
    && mkdir -p /opt/newrelic \
    && curl -L -o /tmp/newrelic-java.zip https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip \
    && unzip /tmp/newrelic-java.zip -d /opt/newrelic \
    && rm -f /tmp/newrelic-java.zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY target/pet-adoption.war /usr/local/tomcat/webapps/pet-adoption.war

EXPOSE 8080

CMD ["/bin/sh", "-c", "if [ -n \"$NEW_RELIC_LICENSE_KEY\" ]; then export CATALINA_OPTS=\"$CATALINA_OPTS -javaagent:/opt/newrelic/newrelic/newrelic.jar -Dnewrelic.config.license_key=$NEW_RELIC_LICENSE_KEY -Dnewrelic.config.app_name=${NEW_RELIC_APP_NAME:-pet-adoption}\"; fi; catalina.sh run"]