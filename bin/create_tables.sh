#!/usr/bin/env bash
echo "THETRANSITCLOCK DOCKER: Creating tables for ${AGENCYID}"

java -cp /usr/local/transitclock/Core.jar org.transitclock.applications.SchemaGenerator -p org.transitclock.db.structs -o /usr/local/transitclock/db
java -cp /usr/local/transitclock/Core.jar org.transitclock.applications.SchemaGenerator -p org.transitclock.db.webstructs -o /usr/local/transitclock/db

createdb \
  -h "${POSTGRES_PORT_5432_TCP_ADDR}" \
  -p "${POSTGRES_PORT_5432_TCP_PORT}" \
  -U postgres \
  "agency-${AGENCYID}"

psql \
  -h "${POSTGRES_PORT_5432_TCP_ADDR}" \
  -p "${POSTGRES_PORT_5432_TCP_PORT}" \
  -U postgres \
  -d "agency-${AGENCYID}" \
  -f /usr/local/transitclock/db/ddl_postgres_org_transitclock_db_structs.sql

psql \
  -h "${POSTGRES_PORT_5432_TCP_ADDR}" \
  -p "${POSTGRES_PORT_5432_TCP_PORT}" \
  -U postgres \
  -d "agency-${AGENCYID}" \
  -f /usr/local/transitclock/db/ddl_postgres_org_transitclock_db_webstructs.sql

echo "THETRANSITCLOCK DOCKER: Finished creating tables for ${AGENCYID}"
