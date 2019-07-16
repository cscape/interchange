#!/usr/bin/env bash
. substitute.sh

ConfigPropsFile="/usr/local/transitclock/config/${AGENCYID}.properties"

cat $ConfigPropsFile
bash