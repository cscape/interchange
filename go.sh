export PGPASSWORD=transitclock

docker stop transitclock-db
docker stop transitclock-server-instance

docker rm transitclock-db
docker rm transitclock-server-instance

docker rmi transitclock-server

docker build --no-cache -t transitclock-server \
--build-arg TRANSITCLOCK_PROPERTIES="config/agency.properties" \
--build-arg AGENCYID="2" \
--build-arg AGENCYNAME="halifax" \
--build-arg GTFS_URL="http://gtfs.halifax.ca/static/google_transit.zip" \
--build-arg GTFSRTVEHICLEPOSITIONS="http://gtfs.halifax.ca/realtime/Vehicle/VehiclePositions.pb" .

docker run --name transitclock-db -p 5432:5432 -e POSTGRES_PASSWORD=$PGPASSWORD -d postgres:9.6.3

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server check_db_up.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server create_tables.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server import_gtfs.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server create_api_key.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server create_webagency.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD  -p 8080:8080 transitclock-server  start_transitclock.sh
