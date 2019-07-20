#!/usr/bin/env bash
sleep 10
echo "Overriding default TheTransitClock Tomcat data..."

SRC="/usr/local/transitclock/config/tomcat"
WAPPS="${CATALINA_HOME}/webapps"

# Tomcat root
cp -f "${SRC}/ROOT_index.jsp" "${WAPPS}/ROOT/index.jsp"
cp -f "${SRC}/favicon.png" "${WAPPS}/ROOT/favicon.png"
rm -f "${WAPPS}/ROOT/favicon.ico"

# Web App
cp -f "${SRC}/general.css" "${WAPPS}/web/css/general.css"
cp -f "${SRC}/index.jsp" "${WAPPS}/web/welcome/index.jsp"
cp -f "${SRC}/header.jsp" "${WAPPS}/web/template/header.jsp"
