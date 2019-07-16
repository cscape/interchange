#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Import GTFS file.'

java \
  -Xmx1024M \
  -Dtransitclock.core.agencyId="${AGENCYID}" \
  -Dtransitclock.configFiles="${TC_PROPERTIES}" \
  -Dtransitclock.logging.dir=/usr/local/transitclock/logs/ \
  -cp /usr/local/transitclock/Core.jar org.transitclock.applications.GtfsFileProcessor \
  -gtfsUrl "${GTFS_URL}" \
  -maxTravelTimeSegmentLength 100

psql \
  -h "${POSTGRES_PORT_5432_TCP_ADDR}" \
  -p "${POSTGRES_PORT_5432_TCP_PORT}" \
  -U postgres \
  -d "TC_AGENCY_${AGENCYID}" \
  -c "update activerevisions set configrev=0 where configrev = -1; update activerevisions set traveltimesrev=0 where traveltimesrev = -1;"
