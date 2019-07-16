#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Start TheTransitClock.'
. substitute.sh

nohup java \
  -Xss12m \
  -Duser.timezone=EST \
  -Dtransitclock.configFiles="/usr/local/transitclock/config/${AGENCYID}.properties" \
  -Dtransitclock.logging.dir="${TRANSITCLOCK_LOGS}" \
  "${SECONDARY_RMI}" \
  -jar /usr/local/transitclock/Core.jar &

# tail -f /dev/null &
