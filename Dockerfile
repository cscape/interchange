FROM openjdk:8-jre

ENV TRANSITCLOCK_LOGS /usr/local/transitclock/logs/

RUN apt-get update
RUN apt-get install -y postgresql-client
RUN apt-get install -y wget
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs

# TOMCAT CONFIG
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.42
ENV TOMCAT_TGZ_URL https://www-us.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
RUN set -x && curl -fsSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz && tar -xvf tomcat.tar.gz --strip-components=1 && rm bin/*.bat && rm tomcat.tar.gz*

# Install json parser so we can read API key for CreateAPIKey output
RUN wget http://stedolan.github.io/jq/download/linux64/jq
RUN chmod +x ./jq
RUN cp jq /usr/bin/

WORKDIR /
RUN mkdir /usr/local/transitclock
RUN mkdir /usr/local/transitclock/db
RUN mkdir /usr/local/transitclock/config
RUN mkdir /usr/local/transitclock/logs
RUN mkdir /usr/local/transitclock/cache
RUN mkdir /usr/local/transitclock/data

WORKDIR /usr/local/transitclock

RUN curl -s https://api.github.com/repos/TheTransitClock/transitime/releases/latest | jq -r ".assets[].browser_download_url" | grep 'Core.jar\|api.war\|web.war' | xargs -L1 wget

# Deploy API which talks to core using RMI calls.
RUN mv api.war  /usr/local/tomcat/webapps

# Deploy webapp which is a UI based on the API.
RUN mv web.war  /usr/local/tomcat/webapps

# Add whole base into Docker
ADD . /usr/local/transitclock

ENV PATH="/usr/local/transitclock/bin:${PATH}"

RUN sed -i 's/\r//' /usr/local/transitclock/bin/*.sh
RUN chmod 777 /usr/local/transitclock/bin/*.sh

EXPOSE 8080

CMD ["/start_transitclock.sh"]
