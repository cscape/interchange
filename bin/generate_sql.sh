#!/usr/bin/env bash

echo 'TRANSITIIME DOCKER: Generate SQL to create tables.'
java -jar $TRANSITIMECORE/transitime/target/SchemaGenerator.jar -p org.transitime.db.structs -o /usr/local/transitime/db/
java -jar $TRANSITIMECORE/transitime/target/SchemaGenerator.jar -p org.transitime.db.webstructs -o /usr/local/transitime/db/

	

