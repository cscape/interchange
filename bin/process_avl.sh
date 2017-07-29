#!/usr/bin/env bash
echo 'TRANSIIIME DOCKER: Process test AVL.'
# This is to substitute into config file the env values. 
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"AGENCYNAME"#"$AGENCYNAME"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"GTFSRTVEHICLEPOSITIONS"#"$GTFSRTVEHICLEPOSITIONS"#g {} \;

# This will process AVL using the set of transitime config files in the test directory.
find /usr/local/transitime/config/test/ -type f -exec java -Xss12m -Duser.timezone=EST -Dtransitime.configFiles={} -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0 \;
