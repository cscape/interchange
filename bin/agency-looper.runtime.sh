#!/usr/bin/env bash
echo 'Starting agency looper for setting up agencies'
. substitute.sh

PRIMARY_AGENCY=
K=0
# Load in each agency & loop
for filename in /usr/local/transitclock/agencies/*.env; do
  [ -e "$filename" ] || continue
  . "${filename}"

  if [ $K -eq 0 ]
  then
    # Only run Create API Key on the primary agency
    AGENCYID="${ID}" . create_api_key.sh
    PRIMARY_AGENCY="${ID}"
  fi

  AGENCYID="${ID}" . create_tables.sh
  AGENCYID="${ID}" GTFS_URL="${GTFS}" . import_gtfs.sh
  PRIMARY_AGENCY="${PRIMARY_AGENCY}" AGENCYID="${ID}" . create_webagency.sh

  K=$((K + 1))
done

echo 'Finished agency looper for setting up agencies'
