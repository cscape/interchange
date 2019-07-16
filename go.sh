export PGPASSWORD=transitclock
export PGUSERNAME=postgres
Tempagencyid=halifax
TempProperties="/usr/local/transitclock/config/halifax.properties"

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

docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e AGENCYID="${Tempagencyid}" \
  transitclock-server \
  substitute.sh

docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e AGENCYID="${Tempagencyid}" \
  transitclock-server \
  create_tables.sh

docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e AGENCYID="${Tempagencyid}" \
  -e TC_PROPERTIES="${TempProperties}" \
  -e GTFS_URL="http://gtfs.halifax.ca/static/google_transit.zip" \
  transitclock-server \
  import_gtfs.sh

docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e TC_PROPERTIES="${TempProperties}" \
  transitclock-server \
  create_api_key.sh

docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e AGENCYID="${Tempagencyid}" \
  transitclock-server \
  create_webagency.sh

# DESCRIPTION:	Start the server
docker run \
  --name transitclock-server-instance \
  --rm \
  --link transitclock-db:postgres \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e PGUSERNAME="${PGUSERNAME}" \
  -e TC_PROPERTIES="${TempProperties}" \
  -e AGENCYID="${Tempagencyid}" \
  -p 3020:8080 \
  transitclock-server \
  start_transitclock.sh
