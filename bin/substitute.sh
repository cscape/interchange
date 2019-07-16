export ConfigPropsFile="/usr/local/transitclock/config/${AGENCYID}.properties"

# This is to substitute into config file the env values.
sed -i -e "s|POSTGRES_PORT_5432_TCP_ADDR|${POSTGRES_PORT_5432_TCP_ADDR}|g" $ConfigPropsFile
sed -i -e "s|POSTGRES_PORT_5432_TCP_PORT|${POSTGRES_PORT_5432_TCP_PORT}|g" $ConfigPropsFile
sed -i -e "s|PGPASSWORD|${PGPASSWORD}|g" $ConfigPropsFile
sed -i -e "s|DATABASE_NAME|TC_AGENCY_${AGENCYID}|g" $ConfigPropsFile
