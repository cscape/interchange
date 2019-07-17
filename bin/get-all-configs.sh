#!/usr/bin/env bash

TOTALCONFIG=
# Load in each agency & loop
for filename in /usr/local/transitclock/config/*.properties; do
  [ -e "$filename" ] || continue
  TOTALCONFIG="$filename;${TOTALCONFIG}"
done

echo "${TOTALCONFIG}"
