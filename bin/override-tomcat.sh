#!/usr/bin/env bash
echo "Overriding default TheTransitClock Tomcat data..."

SRC="/usr/local/transitclock/config/tomcat"
WAPPS="${CATALINA_HOME}/webapps"

# Replace root index page
cp -f "${SRC}/ROOT_index.jsp" "${WAPPS}/ROOT/index.jsp"

cp -f "${SRC}/general.css" "${WAPPS}/web/css/general.css"
cp -f "${SRC}/index.jsp" "${WAPPS}/web/welcome/index.jsp"
cp -f "${SRC}/header.jsp" "${WAPPS}/web/template/header.jsp"
