#!/usr/bin/env bash

psql \
  -h "$POSTGRES_PORT_5432_TCP_ADDR" \
  -p "$POSTGRES_PORT_5432_TCP_PORT" \
  -U postgres \
  -d "TC_AGENCY_${AGENCYID}" \
  -t \
  -c "SELECT applicationkey from apikeys;" | xargs
