#!/usr/bin/env bash
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ ! -f /data/network.configured ]]; then
    export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
    python scripts/network/clear_network_configs.py
    echo "Setting up wifi connection. Connect to the PFC_EDU-${RESIN_DEVICE_NAME_AT_INIT} access point"
    cd /opt/python-wifi-connect/src
    #./scripts/run.sh
    python3.6 http_server.py -d > /data/logs/wifi-connect.txt

    echo "Wifi Configured"
    touch /data/network.configured
fi

cd ${PROJECT_ROOT}

echo "Setting up DB"
${PROJECT_ROOT}/setup_django_db.sh

## IOT SETTINGS
export IOT_PRIVATE_KEY=/data/registration/rsa_private.pem
export CA_CERTS=/data/registration/roots.pem
export GCLOUD_PROJECT=openag-v1
export GCLOUD_REGION=us-central1
export GCLOUD_DEV_REG=device-registry

export REMOTE_DEVICE_UI_URL="https://${BALENA_DEVICE_UUID}.balena-devices.com"

export RUNTIME_MODE="DEVELOPMENT"
# export LOG_LEVEL="DEBUG"

source ${PROJECT_ROOT}/venv/bin/activate

# re-pip install just in case something didn't get built in Docker (e.g. picamera requires being built on a pi)
pip install -r requirements.txt

echo "Setting ENV vars"
source ${PROJECT_ROOT}/set_env_vars.sh

# source ${PROJECT_ROOT}/scripts/install/activate.sh
# busybox httpd -p 8088 -h ${PROJECT_ROOT}/data/images/
if [[ ($DEBUGMODE == "true") ]]; then
  /bin/bash
fi

python3.6 manage.py runserver 0.0.0.0:80 # & python3.6 scripts/platform/rpi_button_handler.py
