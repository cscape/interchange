#!/usr/bin/env bash
echo 'THETRANSITCLOCK DOCKER: Create Tables'
createdb -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres $AGENCYNAME
psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d $AGENCYNAME \
	-f /usr/local/transitclock/db/ddl_postgres_org_transitime_db_structs.sql
psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d $AGENCYNAME \
	-f /usr/local/transitclock/db/ddl_postgres_org_transitime_db_webstructs.sql
