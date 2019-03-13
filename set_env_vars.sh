#!/usr/bin/env bash

### This script will set up the envs based on passed in BALENA

## PLATFORM is set via the dockerfile
PLATFORM="${PLATFORM}"


### FROM get_platform_info.sh
# Defaults
SERIAL_NUMBER="${RESIN_DEVICE_NAME_AT_INIT}"
WIFI_ACCESS_POINT=unknown
IS_WIFI_ENABLED=false
IS_I2C_ENABLED=false
IS_USB_I2C_ENABLED=false
DEFAULT_I2C_BUS=none
DEFAULT_MUX_ADDRESS=0x77

# This matches all raspberry pis
if [[ ($PLATFORM == "raspberry-pi"*) || ($PLATFORM == "raspberrypi"*) ]]; then
  IS_WIFI_ENABLED=true
  IS_I2C_ENABLED=true
  DEFAULT_I2C_BUS=1
  IS_USB_I2C_ENABLED=false
fi

# Beagle Bone Black
if [[ $PLATFORM == "beaglebone-black"* ]]; then
    IS_WIFI_ENABLED=true
    IS_I2C_ENABLED=true
    DEFAULT_I2C_BUS=2
    IS_USB_I2C_ENABLED=false
fi

# Export platform information
export PLATFORM=$PLATFORM
export SERIAL_NUMBER=$SERIAL_NUMBER
export WIFI_ACCESS_POINT=$WIFI_ACCESS_POINT
export REMOTE_DEVICE_UI_URL=$REMOTE_DEVICE_UI_URL
export IS_WIFI_ENABLED=$IS_WIFI_ENABLED
export IS_I2C_ENABLED=$IS_I2C_ENABLED
export IS_USB_I2C_ENABLED=$IS_USB_I2C_ENABLED
export DEFAULT_I2C_BUS=$DEFAULT_I2C_BUS
export DEFAULT_MUX_ADDRESS=$DEFAULT_MUX_ADDRESS

# Show platform information
printf "\nGetting platform info...\n\n"
echo PLATFORM: $PLATFORM
echo SERIAL_NUMBER: $SERIAL_NUMBER
echo WIFI_ACCESS_POINT: $WIFI_ACCESS_POINT
echo REMOTE_DEVICE_UI_URL: $REMOTE_DEVICE_UI_URL
echo IS_WIFI_ENABLED: $IS_WIFI_ENABLED
echo IS_I2C_ENABLED: $IS_I2C_ENABLED
echo IS_USB_I2C_ENABLED: $IS_USB_I2C_ENABLED
echo DEFAULT_I2C_BUS: $DEFAULT_I2C_BUS
echo DEFAULT_MUX_ADDRESS: $DEFAULT_MUX_ADDRESS
echo ""

### From get_network_settings.sh
export LD_LIBRARY_PATH=/usr/local/lib