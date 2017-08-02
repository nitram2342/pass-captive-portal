#!/bin/sh
# Helper script to pass captive portals at places
# where you stay frequently.
#
# Author: Martin Schobert <martin@weltregierung.de>
#


PROGRAM_DIR="$(dirname "$0")"
SCRIPT_DIR=$PROGRAM_DIR/scripts

# load configuration

if [ -f "$PROGRAM_DIR/config.default" ]; then
    . "$PROGRAM_DIR/config.default"
fi

if [ -f "$PROGRAM_DIR/config" ]; then
    . "$PROGRAM_DIR/config"
fi

if [ "$DEVICE" = "" ]; then
    echo "+ Failed to load a config file"
    exit
fi

echo "+ Using WiFi device: $DEVICE"

MAC_ADDRESS=$(cat /sys/class/net/$DEVICE/address)
echo "+ Current MAC address is: $MAC_ADDRESS"


# Get current WiFi network
CURRENT_SSID=`iwgetid $DEVICE -r`
echo "+ Current SSID is: $CURRENT_SSID"


# check if WiFi network is known
if [ "$CURRENT_SSID" = "WIFIonICE" ] ; then
    echo "+ Launch script"
    $SCRIPT_DIR/wifionice.sh
elif [ "$CURRENT_SSID" = "FREE MEE" ] ; then
    echo "+ Launch script"
    $SCRIPT_DIR/free_mee.sh $DEVICE $MAC_ADDRESS
else
    echo "+ Unkown SSID, will be ignored"
    exit
fi

if [ $? = 0 ]; then
    echo "+ Script was successful."
else
    echo "+ Error: Script failed. Sopping here."
    exit
fi

# check success
echo "+ Send test request to: $URL_TO_TEST"
curl --silent  "$URL_TO_TEST" | grep "$EXPECTED_STR"
if [ $? = 0 ]; then
    echo "+ Success: Captive portal passed"
else
    echo "+ Error: Captive portal not passed"
fi
