#!/bin/sh
#
# Author: Jan Girlich (@vollkorn1982)
#

WLAN_IF="wlp3s0"
OUTPUT="/dev/null"
#OPTS="-k -x 127.0.0.1:8080" # use proxy and ignore certificate errors
COOKIE_JAR="~/.cookie-jar.txt"

echo "Send request to get captive portal"
curl $OPTS --silent --output $OUTPUT -c $COOKIE_JAR -L http://lala.de/

echo "accept AGB and TOS"
# Encode mac address correctly
MAC="$(cat /sys/class/net/$WLAN_IF/address | sed -r 's/:/%3A/g')"

curl $OPTS --silent --output $OUTPUT --cookie "AGB_TOS_FREEMEE=1" -L --data "mac=$MAC" http://portal.free-mee.com/sources/agb_tos.php

echo "send key to unlock Internet"
curl $OPTS --silent --output $OUTPUT -b $COOKIE_JAR -L "http://n193.network-auth.com/splash/grant?acceptedAGB=1&acceptedTOS=1"
