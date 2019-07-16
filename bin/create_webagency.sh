#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create WebAgency.'
# This is to substitute into config file the env values
find /usr/local/transitclock/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;

java \
  -Dtransitclock.db.dbName="TC_AGENCY_${AGENCYID}" \
  -Dtransitclock.hibernate.configFile="/usr/local/transitclock/config/hibernate.cfg.xml" \
  -Dtransitclock.db.dbHost="${POSTGRES_PORT_5432_TCP_ADDR}:${POSTGRES_PORT_5432_TCP_PORT}" \
  -Dtransitclock.db.dbUserName="postgres" \
  -Dtransitclock.db.dbPassword="${PGPASSWORD}" \
  -Dtransitclock.db.dbType="postgresql" \
  -cp /usr/local/transitclock/Core.jar org.transitclock.db.webstructs.WebAgency \
  "${AGENCYID}" \
  127.0.0.1 \
  "TC_AGENCY_${AGENCYID}" \
  postgresql \
  $POSTGRES_PORT_5432_TCP_ADDR \
  postgres \
  $PGPASSWORD
