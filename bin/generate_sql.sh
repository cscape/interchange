#!/usr/bin/env bash

echo 'THETRANSITCLOCK DOCKER: Generate SQL to create tables.'

java -jar $TRANSITCLOCK_CORE/transitclock/target/SchemaGenerator.jar -p org.transitclock.db.structs -o /usr/local/transitclock/db/
java -jar $TRANSITCLOCK_CORE/transitclock/target/SchemaGenerator.jar -p org.transitclock.db.webstructs -o /usr/local/transitclock/db/
