#!/usr/bin/env bash
echo "THETRANSITCLOCK DOCKER: Import GTFS file for ${AGENCYID}"
. substitute.sh

java \
  -Dtransitclock.logging.dir=/tmp \
  -Dtransitclock.configFiles="/usr/local/transitclock/config/${AGENCYID}.properties" \
  -cp /usr/local/transitclock/Core.jar org.transitclock.applications.GtfsFileProcessor \
  -c "/usr/local/transitclock/config/${AGENCYID}.properties" \
  -storeNewRevs \
  -skipDeleteRevs \
  -gtfsUrl "${GTFS_URL}"

psql \
  -h "${POSTGRES_PORT_5432_TCP_ADDR}" \
  -p "${POSTGRES_PORT_5432_TCP_PORT}" \
  -U postgres \
  -d "agency-${AGENCYID}" \
  -c "update activerevisions set configrev=0 where configrev = -1; update activerevisions set traveltimesrev=0 where traveltimesrev = -1;"

echo "THETRANSITCLOCK DOCKER: Finished importing GTFS file for ${AGENCYID}"
