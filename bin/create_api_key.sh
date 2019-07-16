#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create API key.'
. substitute.sh

# ONLY CREATE THIS API KEY
# FOR THE PRIMARY CORE

java \
  -cp /usr/local/transitclock/Core.jar org.transitclock.applications.CreateAPIKey \
  -c "${TC_PROPERTIES}" \
  -d "foo" \
  -e "og.crudden@gmail.com" \
  -n "Sean Og Crudden" \
  -p "123456" \
  -u "http://www.transitclock.org"
