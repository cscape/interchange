#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create WebAgency.'

# WebAgency MUST be created on the primary core

java \
  -Dtransitclock.db.dbName="agency-${PRIMARY_AGENCY}" \
  -Dtransitclock.hibernate.configFile="/usr/local/transitclock/config/hibernate.cfg.xml" \
  -Dtransitclock.db.dbHost="${POSTGRES_PORT_5432_TCP_ADDR}:${POSTGRES_PORT_5432_TCP_PORT}" \
  -Dtransitclock.db.dbUserName="postgres" \
  -Dtransitclock.db.dbPassword="${PGPASSWORD}" \
  -Dtransitclock.db.dbType="postgresql" \
  -cp /usr/local/transitclock/Core.jar org.transitclock.db.webstructs.WebAgency \
  "${AGENCYID}" \
  127.0.0.1 \
  "agency-${PRIMARY_AGENCY}" \
  postgresql \
  "${POSTGRES_PORT_5432_TCP_ADDR}" \
  postgres \
  "${PGPASSWORD}"
