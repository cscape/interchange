#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create WebAgency.'
# This is to substitute into config file the env values
find /usr/local/transitclock/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"AGENCYNAME"#"$AGENCYNAME"#g {} \;
find /usr/local/transitclock/config/ -type f -exec sed -i s#"GTFSRTVEHICLEPOSITIONS"#"$GTFSRTVEHICLEPOSITIONS"#g {} \;

java -Dtransitime.db.dbName=$AGENCYNAME -Dtransitime.hibernate.configFile=/usr/local/transitclock/config/hibernate.cfg.xml -Dtransitime.db.dbHost=$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT -Dtransitime.db.dbUserName=postgres -Dtransitime.db.dbPassword=$PGPASSWORD -Dtransitime.db.dbType=postgresql -cp usr/local/transitclock/Core.jar org.transitime.db.webstructs.WebAgency $AGENCYID 127.0.0.1 $AGENCYNAME postgresql $POSTGRES_PORT_5432_TCP_ADDR postgres $PGPASSWORD
