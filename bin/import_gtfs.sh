#!/usr/bin/env bash
echo 'TRANSIIIME DOCKER: Import GTFS file.'
# This is to substitute into config file the env values. 
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"AGENCYNAME"#"$AGENCYNAME"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"GTFSRTVEHICLEPOSITIONS"#"$GTFSRTVEHICLEPOSITIONS"#g {} \;


java -Xmx1024M -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.configFiles=/usr/local/transitime/config/transiTimeConfig.xml -Dtransitime.logging.dir=/usr/local/transitime/logs/ -Dlogback.configurationFile=$TRANSITIMECORE/transitime/src/main/resouces/logbackGtfs.xml -jar $TRANSITIMECORE/transitime/target/GtfsFileProcessor.jar -gtfsZipFileName /usr/local/transitime/data/gtfs_hart_old.zip -maxTravelTimeSegmentLength 400

psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d $AGENCYNAME \
	-c "update activerevisions set configrev=0 where configrev = -1; update activerevisions set traveltimesrev=0 where traveltimesrev = -1;"

