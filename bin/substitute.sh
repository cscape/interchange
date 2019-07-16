#!/usr/bin/env bash

echo "Setting substitutes..."

for filename in /usr/local/transitclock/config/*.properties; do
  [ -e "$filename" ] || continue
  sed -i "s|*POSTGRES_PORT_5432_TCP_ADDR|${POSTGRES_PORT_5432_TCP_ADDR}|g" "$filename"
  sed -i "s|*POSTGRES_PORT_5432_TCP_PORT|${POSTGRES_PORT_5432_TCP_PORT}|g" "$filename"
  sed -i "s|*PGPASSWORD|${PGPASSWORD}|g" "$filename"
done

echo "Finished setting substitutes"
