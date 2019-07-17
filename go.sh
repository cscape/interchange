#!/usr/bin/env bash
export PGPASSWORD=transitclock
export PGUSERNAME=postgres

docker stop transitclock-db && docker stop transitclock-server-instance
docker rm transitclock-db && docker rm transitclock-server-instance

docker rmi transitclock-server

# Builds image from Dockerfile
docker build --no-cache -t transitclock-server .

# Initiates the database container
docker run \
  --name transitclock-db \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD="${PGPASSWORD}" \
  -e POSTGRES_USER="${PGUSERNAME}" \
  -d \
  postgres:9.6.12

# Check that the database is up
docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e PGUSERNAME="${PGUSERNAME}" \
  transitclock-server \
  check_db_up.sh

# Sets up the database and necessary stuff
docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e PGUSERNAME="${PGUSERNAME}" \
  transitclock-server \
  agency-looper.runtime.sh

# Starts TransitClock cores
docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e PGUSERNAME="${PGUSERNAME}" \
  transitclock-server \
  agency-looper.start.sh

# Starts Tomcat
docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e PGUSERNAME="${PGUSERNAME}" \
  -p 3020:8080 \
  transitclock-server \
  finalboot.sh
