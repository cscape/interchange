#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Import GTFS file.'
set -u
. substitute.sh

java \
  -Dtransitclock.logging.dir=/tmp \
  -cp /usr/local/transitclock/Core.jar org.transitclock.applications.GtfsFileProcessor \
  -c "/usr/local/transitclock/config/${AGENCYID}.properties" \
  -storeNewRevs \
  -skipDeleteRevs \
  -gtfsUrl "${GTFS_URL}" \
  -maxTravelTimeSegmentLength 100

psql \
  -h "${POSTGRES_PORT_5432_TCP_ADDR}" \
  -p "${POSTGRES_PORT_5432_TCP_PORT}" \
  -U postgres \
  -d "agency-${AGENCYID}" \
  -c "update activerevisions set configrev=0 where configrev = -1; update activerevisions set traveltimesrev=0 where traveltimesrev = -1;"
