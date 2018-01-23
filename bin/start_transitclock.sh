#!/usr/bin/env bash
echo 'TRANSIIIME DOCKER: Start transiTime.'
# This is to substitute into config file the env values
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"AGENCYNAME"#"$AGENCYNAME"#g {} \;
find /usr/local/transitime/config/ -type f -exec sed -i s#"GTFSRTVEHICLEPOSITIONS"#"$GTFSRTVEHICLEPOSITIONS"#g {} \;

rmiregistry &

#set the API as an environment variable so we can set in JSP of template/includes.jsp in the transitime webapp
export APIKEY=$(/get_api_key.sh)

# make it so we can also access as a system property in the JSP
export JAVA_OPTS="$JAVA_OPTS -Dtransitime.apikey=$(/get_api_key.sh)"

echo JAVA_OPTS $JAVA_OPTS

/usr/local/tomcat/bin/startup.sh

nohup java -Xss12m -Duser.timezone=EST -Dtransitime.configFiles=/usr/local/transitime/config/transiTimeConfig.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0 > /usr/local/transitime/logs/output.txt &

tail -f /dev/null