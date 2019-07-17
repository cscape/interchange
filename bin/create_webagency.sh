#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create WebAgency.'

java \
  -Dtransitclock.db.dbName="agency-${AGENCYID}" \
  -Dtransitclock.hibernate.configFile="/usr/local/transitclock/config/hibernate.cfg.xml" \
  -Dtransitclock.db.dbHost="${POSTGRES_PORT_5432_TCP_ADDR}:${POSTGRES_PORT_5432_TCP_PORT}" \
  -Dhibernate.connection.url="jdbc:postgresql://${POSTGRES_PORT_5432_TCP_ADDR}:${POSTGRES_PORT_5432_TCP_PORT}/agency-${AGENCYID}" \
  -Dtransitclock.db.dbUserName="postgres" \
  -Dhibernate.connection.username="postgres" \
  -Dtransitclock.db.dbPassword="${PGPASSWORD}" \
  -Dhibernate.connection.password="${PGPASSWORD}" \
  -Dtransitclock.db.dbType="postgresql" \
  -cp /usr/local/transitclock/Core.jar org.transitclock.db.webstructs.WebAgency \
  "${AGENCYID}" \
  127.0.0.1 \
  "agency-${AGENCYID}" \
  postgresql \
  "${POSTGRES_PORT_5432_TCP_ADDR}" \
  postgres \
  "${PGPASSWORD}"
