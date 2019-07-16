export ConfigPropertiesPath="/usr/local/transitclock/config/${AGENCYID}.properties"

# This is to substitute into config file the env values.
find $ConfigPropertiesPath -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g {} \;
find $ConfigPropertiesPath -type f -exec sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g {} \;
find $ConfigPropertiesPath -type f -exec sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g {} \;
find $ConfigPropertiesPath -type f -exec sed -i s#"DATABASE_NAME"#"TC_AGENCY_${AGENCYID}"#g {} \;
