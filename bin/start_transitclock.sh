#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Start TheTransitClock.'
AGENCYID="${AGENCYID}" . substitute.sh

rmiregistry &

#set the API as an environment variable so we can set in JSP of template/includes.jsp in the transitime webapp
export APIKEY=$(get_api_key.sh)

# make it so we can also access as a system property in the JSP
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.apikey=$(get_api_key.sh)"
export JAVA_OPTS="$JAVA_OPTS -Dtransitclock.configFiles=${TC_PROPERTIES}"

/usr/local/tomcat/bin/startup.sh

nohup java \
  -Xss12m \
  -Duser.timezone=EST \
  -Dtransitclock.configFiles="${TC_PROPERTIES}" \
  -Dtransitclock.core.agencyId="${AGENCYID}" \
  -Dtransitclock.logging.dir="${TRANSITCLOCK_LOGS}" \
  -jar /usr/local/transitclock/Core.jar \
  -configRev 0 \
  > /usr/local/transitclock/logs/output.txt &

tail -f /dev/null
