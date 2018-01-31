export PGPASSWORD=transitclock

docker stop transitclock-db
docker stop transitclock-server-instance

docker rm transitclock-db
docker rm transitclock-server-instance

docker rmi transitclock-server

docker build -t transitclock-server \
--build-arg TRANSITCLOCK_GITHUB="https://github.com/TheTransitClock/transitime.git" \
--build-arg TRANSITCLOCK_BRANCH="tc_issue_37" \
--build-arg TRANSITCLOCK_PROPERTIES="config/transitclockConfig.xml" \
--build-arg AGENCYID="1" \
--build-arg AGENCYNAME="CAPMETRO" \
--build-arg GTFS_URL="https://data.texas.gov/download/r4v4-vz24/application%2Fzip" \
--build-arg GTFSRTVEHICLEPOSITIONS="https://data.texas.gov/download/eiei-9rpf/application%2Foctet-stream" .

docker run --name transitclock-db -p 5432:5432 -e POSTGRES_PASSWORD=$PGPASSWORD -d postgres:9.6.3

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server ./check_db_up.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server ./create_tables.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server ./import_gtfs.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server ./create_api_key.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server ./create_webagency.sh

#docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server ./import_avl.sh

#docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD transitclock-server ./process_avl.sh

docker run --name transitclock-server-instance --rm --link transitclock-db:postgres -e PGPASSWORD=$PGPASSWORD  -p 8080:8080 transitclock-server  ./start_transitclock.sh
