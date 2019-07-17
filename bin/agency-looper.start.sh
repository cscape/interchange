#!/usr/bin/env bash
echo 'Starting up all TransitClock agencies'
. substitute.sh

rmiregistry &

M=0
FIRSTAGENCYID=""
# Load in each agency & loop
for filename in /usr/local/transitclock/agencies/*.env; do
  [ -e "$filename" ] || continue
  . "${filename}"
  AGENCYID="${ID}"
  GTFS_URL="${GTFS}"
  SECONDARY_RMI="-Dtransitclock.rmi.secondaryRmiPort=0"
  SECONDARY_RMISTATUS=true

  if [ $M -eq 0 ]; then
    # Start Tomcat using the 1st agency's API key
    FIRSTAGENCYID="${ID}"
    SECONDARY_RMISTATUS=false
  fi

  # if [[ "$SECONDARY_RMISTATUS" == "true" ]]; then
    # # Leave this blank so it's not put into the core as an argument
    # echo "Setting SECONDARY_RMI as blank"
    # SECONDARY_RMI=""
  # fi

  AGENCYID="${ID}" SECONDARY_RMI="${SECONDARY_RMI}" . start_core.sh
  PRIMARY_AGENCY="${FIRSTAGENCYID}" AGENCYID="${ID}" . create_webagency.sh

  if [ $M -eq 0 ]; then
    echo "Wait for 8 seconds, ensuring primary core loads..."
    sleep 8
  fi

  M=$((M + 1))
done

# J=0
# Load in each agency & loop
for filename in /usr/local/transitclock/agencies/*.env; do
  [ -e "$filename" ] || continue
  . "${filename}"

  # if [ $J -eq 0 ]; then
    # Only run Create API Key on the primary agency
    AGENCYID="${ID}" . create_api_key.sh
  # fi
  # J=$((J + 1))
done

echo "THETRANSITCLOCK DOCKER: Finished launching all cores"

AGENCYID="${FIRSTAGENCYID}" . start_tomcat.sh

tail -f /dev/null
