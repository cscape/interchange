#!/usr/bin/env bash
echo 'Starting agency looper for setting up agencies'
. substitute.sh

# Load in each agency & loop
for filename in /usr/local/transitclock/agencies/*.env; do
  [ -e "$filename" ] || continue
  source $filename
  TC_PROPERTIES="/usr/local/transitclock/config/${ID}.properties"
  AGENCYID="${ID}"
  GTFS_URL="${GTFS}"

  AGENCYID="${AGENCYID}" . create_tables.sh
  AGENCYID="${AGENCYID}" TC_PROPERTIES="${TC_PROPERTIES}" GTFS_URL="${GTFS_URL}" . import_gtfs.sh
  AGENCYID="${AGENCYID}" TC_PROPERTIES="${TC_PROPERTIES}" . create_api_key.sh
  AGENCYID="${AGENCYID}" . create_webagency.sh
done

echo 'Finished agency looper for setting up agencies'
