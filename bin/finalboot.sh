#!/usr/bin/env bash
echo 'Starting up all TransitClock agencies'
. substitute.sh

K=0
# Load in each agency & loop
for filename in /usr/local/transitclock/agencies/*.env; do
  [ -e "$filename" ] || continue
  . "${filename}"

  if [ $K -eq 0 ]; then
    AGENCYID="${ID}" . start_tomcat.sh
  fi
  K=$((K + 1))
done

tail -f /dev/null
