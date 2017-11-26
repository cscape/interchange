export PGPASSWORD=transitime

docker stop transitime-db
docker stop transitime-server-instance

docker rm transitime-db
docker rm transitime-server-instance

docker rmi transitime-server

docker build -t transitime-server \
--build-arg TRANSITIME_GITHUB="https://github.com/TheTransitClock/transitime.git" \
--build-arg TRANSITIME_BRANCH="VIA" \
--build-arg AGENCYNAME=GOHART \
--build-arg GTFS_URL="http://gohart.org/google/google_transit.zip" \
--build-arg GTFSRTVEHICLEPOSITIONS="http://realtime.prod.obahart.org:8088/vehicle-positions" .

docker run --name transitime-db -p 5432:5432 -e POSTGRES_PASSWORD=$PGPASSWORD -d postgres:9.6.3

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD transitime-server ./check_db_up.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD transitime-server ./create_tables.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD transitime-server ./import_gtfs.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD transitime-server ./create_api_key.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD transitime-server ./create_webagency.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD transitime-server ./import_avl.sh

docker run --name transitime-server-instance --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD transitime-server ./process_avl.sh

#docker run --name transitime-server-instance --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD  -p 8080:8080 transitime-server  ./start_transitime.sh
