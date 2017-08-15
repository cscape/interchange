#!/usr/bin/env bash
echo 'TRANSIIIME DOCKER: Process test AVL.'
# This is to substitute into config file the env values. 
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"AGENCYNAME"#"$AGENCYNAME"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"GTFSRTVEHICLEPOSITIONS"#"$GTFSRTVEHICLEPOSITIONS"#g {} \;

# This will process AVL using the set of transitime config files in the test directory.
#find /usr/local/transitime/config/test/ -type f | sort -n | xargs -I {} java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles={} -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0 \;
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig1.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig1.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/UpdateTravelTimes.jar 07-10-2017

java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig2.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig1.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/UpdateTravelTimes.jar 07-11-2017

java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig3.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig1.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/UpdateTravelTimes.jar 07-12-2017

java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig4.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0
java -Xmx2048m -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/test/transiTimeConfig1.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/UpdateTravelTimes.jar 07-13-2017
