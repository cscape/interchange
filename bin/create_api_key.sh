#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create API key.'
AGENCYID="${AGENCYID}" . substitute.sh

java \
  -cp /usr/local/transitclock/Core.jar org.transitclock.applications.CreateAPIKey \
  -c "${TC_PROPERTIES}" \
  -d "foo" \
  -e "og.crudden@gmail.com" \
  -n "Sean Og Crudden" \
  -p "123456" \
  -u "http://www.transitclock.org"
