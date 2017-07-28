#!/bin/sh
#
# Author: Jan Girlich (@vollkorn1982)
#
# This script has a known bug. // martin
#

# 
# * Anfrage an beliebige URL
# * redirect folgen
# * Aus der Response p_splash_session speichern
# * redirect folgen (evtl. optional)
#
# * POST /sources/agb_tos.php HTTP/1.1
# Mit passender IP-Adresse (+mac)
#
# * GET /splash/grant?acceptedAGB=1&acceptedTOS=1 HTTP/1.1
# mit passendem p_splash
# * 1. Redirect folgen

WLAN_IF=$1
MAC_ADDRESS=$2

OUTPUT=/dev/null

echo "Send request to get captive portal"
curl --silent --output $OUTPUT -c cookie-jar.txt -L http://lala.de/

echo "accept AGB and TOS"
curl --silent --output $OUTPUT --data-urlencode "fm_touchpoint_id=130368&fm_video_id=0&fm_splash_page_id=44&fm_mac=${MAC_ADDRESS}&fm_touchpoint=1&fm_video_insert=0&AGB_TOS_FREEMEE=1" http://portal-test.free-mee.com/sources/agb_tos.php

echo "send key to unlock Internet"
curl --silent --output $OUTPUT -c cookie-jar.txt -L http://n193.network-auth.com/splash/grant?acceptedAGB=1&acceptedTOS=1

