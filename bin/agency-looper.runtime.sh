#!/usr/bin/env bash
echo 'Starting agency looper for setting up agencies'
. substitute.sh

K=0
# Load in each agency & loop
for filename in /usr/local/transitclock/agencies/*.env; do
  [ -e "$filename" ] || continue
  source $filename
  TC_PROPERTIES="/usr/local/transitclock/config/${ID}.properties"
  AGENCYID="${ID}"
  GTFS_URL="${GTFS}"

  AGENCYID="${AGENCYID}" . create_tables.sh
  AGENCYID="${AGENCYID}" TC_PROPERTIES="${TC_PROPERTIES}" GTFS_URL="${GTFS_URL}" . import_gtfs.sh
  AGENCYID="${AGENCYID}" . create_webagency.sh
  if [ $K -eq 0 ]
  then
    # Only run Create API Key on the primary agency
    TC_PROPERTIES="${TC_PROPERTIES}" . create_api_key.sh
  fi
  ((K++))
done

echo 'Finished agency looper for setting up agencies'
