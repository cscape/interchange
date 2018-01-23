FROM maven:3.3-jdk-8
MAINTAINER Nathan Walker <nathan@rylath.net>, Sean Óg Crudden <og.crudden@gmail.com>

ARG AGENCYID="1"
ARG AGENCYNAME="GOHART"
# Latest version not used for doing prediction comparison
ARG GTFS_URL="http://gohart.org/google/google_transit.zip"
ARG GTFSRTVEHICLEPOSITIONS="http://realtime.prod.obahart.org:8088/vehicle-positions"
ARG TRANSITCLOCK_GITHUB="https://github.com/TheTransitClock/transitime.git"
ARG TRANSITCLOCK_BRANCH="develop"
ARG TRANSITCLOCK_PROPERTIES="config/transitclockConfig.xml"


ENV AGENCYID ${AGENCYID}
ENV AGENCYNAME ${AGENCYNAME}
ENV GTFS_URL ${GTFS_URL}
ENV GTFSRTVEHICLEPOSITIONS ${GTFSRTVEHICLEPOSITIONS}
ENV TRANSITCLOCK_GITHUB ${TRANSITCLOCK_GITHUB}
ENV TRANSITCLOCK_BRANCH ${TRANSITCLOCK_BRANCH}
ENV TRANSITCLOCK_PROPERTIES ${TRANSITCLOCK_PROPERTIES}

ENV TRANSITCLOCK_CORE /transitclock-core

RUN apt-get update \
	&& apt-get install -y postgresql-client \
	&& apt-get install -y git-core \
	&& apt-get install -y vim

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
	05AB33110949707C93A279E3D3EFE6B686867BA6 \
	07E48665A34DCAFAE522E5E6266191C37C037D42 \
	47309207D818FFD8DCD3F83F1931D684307A10A5 \
	541FBE7D8F78B25E055DDEE13C370389288584E7 \
	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
	9BA44C2621385CB966EBA586F72C284D731FABEE \
	A27677289986DB50844682F8ACB77FC2E86E29AC \
	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
	F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.43
ENV TOMCAT_TGZ_URL https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

EXPOSE 8080


# Install json parser so we can read API key for CreateAPIKey output

RUN wget http://stedolan.github.io/jq/download/linux64/jq

RUN chmod +x ./jq

RUN cp jq /usr/bin/

RUN git clone ${TRANSITCLOCK_GITHUB} ${TRANSITCLOCK_CORE}

WORKDIR ${TRANSITCLOCK_CORE}

RUN git checkout ${TRANSITCLOCK_BRANCH}

RUN mvn install -DskipTests

WORKDIR /
RUN mkdir /usr/local/transitclock
RUN mkdir /usr/local/transitclock/db
RUN mkdir /usr/local/transitclock/config
RUN mkdir /usr/local/transitclock/logs
RUN mkdir /usr/local/transitclock/cache
RUN mkdir /usr/local/transitclock/data
RUN mkdir /usr/local/transitclock/test
RUN mkdir /usr/local/transitclock/test/config



# Deploy core. The work horse of transiTime.
RUN cp ${TRANSITCLOCK_CORE}/transitclock/target/*.jar /usr/local/transitclock/

# Deploy API which talks to core using RMI calls.
RUN cp ${TRANSITCLOCK_CORE}/transitclockApi/target/api.war  /usr/local/tomcat/webapps

# Deploy webapp which is a UI based on the API.
RUN cp ${TRANSITCLOCK_CORE}/transitclockWebapp/target/web.war  /usr/local/tomcat/webapps

RUN cp ${TRANSITCLOCK_CORE}/transitclock/target/classes/ddl_postgres*.sql /usr/local/transitclock/db

# RUN rm -rf /transitclock-core

# RUN rm -rf ~/.m2/repository

# Scripts required to start transiTime.
ADD bin/check_db_up.sh check_db_up.sh
ADD bin/generate_sql.sh generate_sql.sh
ADD bin/create_tables.sh create_tables.sh
ADD bin/create_api_key.sh create_api_key.sh
ADD bin/create_webagency.sh create_webagency.sh
ADD bin/import_gtfs.sh import_gtfs.sh
ADD bin/start_transitclock.sh start_transitclock.sh
ADD bin/get_api_key.sh get_api_key.sh
ADD bin/import_avl.sh import_avl.sh
ADD bin/process_avl.sh process_avl.sh
ADD bin/update_traveltimes.sh update_traveltimes.sh
ADD bin/set_config.sh set_config.sh

# Handy utility to allow you connect directly to database
ADD bin/connect_to_db.sh connect_to_db.sh

# This is a way to copy in test data to run a regression test.
ADD data/avl.csv /usr/local/transitclock/data/avl.csv
ADD data/gtfs_hart_old.zip /usr/local/transitclock/data/gtfs_hart_old.zip


# RUN ./generate_sql.sh

RUN \
	sed -i 's/\r//' *.sh &&\
 	chmod 777 *.sh

ADD config/postgres_hibernate.cfg.xml /usr/local/transitclock/config/hibernate.cfg.xml
ADD ${TRANSITCLOCK_PROPERTIES} /usr/local/transitclock/config/transitclockConfig.xml

# This adds the transitime configs to test.
ADD config/test/* /usr/local/transitclock/config/test/


EXPOSE 8080

CMD ["/start_transitclock.sh"]
