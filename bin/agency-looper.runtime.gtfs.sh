#!/usr/bin/env bash
echo 'Starting agency looper for setting up GTFS imports'
. substitute.sh

# Load in each agency & loop
for filename in /usr/local/transitclock/agencies/*.env; do
  [ -e "$filename" ] || continue
  . "${filename}"

  AGENCYID="${ID}" GTFS_URL="${GTFS}" . import_gtfs.sh
done

echo 'Finished agency looper for setting up GTFS imports'
