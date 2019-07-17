#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Start Tomcat/Catalina'

rmiregistry &

#set the API as an environment variable so we can set in JSP of template/includes.jsp in the transitime webapp
export APIKEY=$(AGENCYID="${AGENCYID}" . get_api_key.sh)
export CATALINA_OPTS="$CATALINA_OPTS -Dtransitclock.db.dbType=postgresql -Dtransitclock.apikey=${APIKEY}"

/usr/local/tomcat/bin/startup.sh
