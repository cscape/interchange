#!/usr/bin/env bash

# ONLY USE THE PRIMARY AGENCY ID.
# TO BE USED BY PRIMARY CORE

psql \
  -h "${POSTGRES_PORT_5432_TCP_ADDR}" \
  -p "${POSTGRES_PORT_5432_TCP_PORT}" \
  -U postgres \
  -d "agency-${AGENCYID}" \
  -t \
  -c "SELECT applicationkey from apikeys;" | xargs
