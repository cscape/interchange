#!/usr/bin/env bash
echo "THETRANSITCLOCK DOCKER: Create API key for ${AGENCYID}"
set -u
. substitute.sh

# ONLY CREATE THIS API KEY
# FOR THE PRIMARY CORE

java \
  -cp /usr/local/transitclock/Core.jar org.transitclock.applications.CreateAPIKey \
  -c "\"/usr/local/transitclock/config/${AGENCYID}.properties\"" \
  -n "Sean Og Crudden" \
  -u "http://www.transitclock.org" \
  -e "og.crudden@gmail.com" \
  -p "123456" \
  -d "foo"

echo "THETRANSITCLOCK DOCKER: Finished creating API key for ${AGENCYID}"
