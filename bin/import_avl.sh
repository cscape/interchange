#!/usr/bin/env bash
echo 'TRANSIIIME DOCKER: Import test AVL.'

psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d $AGENCYNAME \
	-c "\COPY avlreports FROM '/usr/local/transitime/data/avl.csv';"
