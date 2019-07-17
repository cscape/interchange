#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Start Tomcat/Catalina'

rmiregistry &

# set the API as an environment variable so we can set in JSP of template/includes.jsp in the transitime webapp
export APIKEY=$(AGENCYID="${AGENCYID}" . get_api_key.sh)

# Connection info to the PRIMARY AGENCY database for Tomcat
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.apikey=${APIKEY} \
-Dtransitclock.configFiles=/usr/local/transitclock/config/${AGENCYID}.properties"
# -Dtransitclock.hibernate.configFile=/usr/local/transitclock/config/hibernate.cfg.xml \
# -Dtransitclock.db.dbHost=${POSTGRES_PORT_5432_TCP_ADDR}:${POSTGRES_PORT_5432_TCP_PORT} \
# -Dhibernate.connection.url=jdbc:postgresql://${POSTGRES_PORT_5432_TCP_ADDR}:${POSTGRES_PORT_5432_TCP_PORT}/ \
# -Dtransitclock.db.dbUserName=postgres \
# -Dhibernate.connection.username=postgres \
# -Dtransitclock.db.dbPassword=${PGPASSWORD} \
# -Dhibernate.connection.password=${PGPASSWORD} \
# -Dtransitclock.db.dbType=postgresql"

/usr/local/tomcat/bin/startup.sh
