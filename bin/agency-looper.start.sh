#!/usr/bin/env bash
echo 'Starting up all TransitClock agencies'
. substitute.sh

K=0
# Load in each agency & loop
for filename in /usr/local/transitclock/agencies/*.env; do
  [ -e "$filename" ] || continue
  . "${filename}"
  AGENCYID="${ID}"
  GTFS_URL="${GTFS}"
  SECONDARY_RMI="-Dtransitclock.rmi.secondaryRmiPort=0"
  SECONDARY_RMISTATUS=true

  if [ $K -eq 0 ]; then
    # Start Tomcat using the 1st agency's API key
    AGENCYID="${ID}" . start_tomcat.sh
    SECONDARY_RMISTATUS=false
  fi

  if [ "$SECONDARY_RMISTATUS" = true ]; then
    # Leave this blank so it's not put into the core as an argument
    SECONDARY_RMI=""
  fi

  AGENCYID="${ID}" SECONDARY_RMI="${SECONDARY_RMI}" . start_core.sh

  K=$((K + 1))
done

echo 'Finished starting up all TransitClock agencies'
