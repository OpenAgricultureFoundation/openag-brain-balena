#!/usr/bin/env bash
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Stop the mdns responder till things settle down
# python3.6 ${PROJECT_ROOT}/scripts/network/stop_mdns.py

cd ${PROJECT_ROOT}
echo "Setting up DB"
${PROJECT_ROOT}/setup_django_db.sh

if [[ ! -f /data/network.configured  && -f /data/system.configured ]]; then
    export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
    python scripts/network/clear_network_configs.py
    echo "Setting up wifi connection. Connect to the PFC-EDU-${RESIN_DEVICE_NAME_AT_INIT} access point"
    cd /opt/python-wifi-connect/src
    #./scripts/run.sh

    if [[ -f /data/registration/verification_code.txt ]]; then
      python3.6 http_server.py -d -r `cat /data/registration/verification_code.txt`
    else
      python3.6 http_server.py -d
    fi

    echo "Wifi Configured"
    touch /data/network.configured
fi

if [[ "${HOSTNAME}" != "pfc-edu-${RESIN_DEVICE_NAME_AT_INIT}" ]]; then
    echo "Chaging hostname to pfc-edu-${RESIN_DEVICE_NAME_AT_INIT}"
    curl -X PATCH --header "Content-Type:application/json" --data "{\"network\": {\"hostname\": \"pfc-edu-${RESIN_DEVICE_NAME_AT_INIT}\"}}" "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY"
fi


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
#echo "Calling restart_mdns.py"
#python3.6 ${PROJECT_ROOT}/scripts/network/restart_mdns.py

# re-pip install just in case something didn't get built in Docker (e.g. picamera requires being built on a pi)
pip install -r requirements.txt

echo "Setting ENV vars"
source ${PROJECT_ROOT}/set_env_vars.sh

# If we made it here, and the 'system.configured' file doesn't exist, this is the end of first boot, so make it.
if [[ ! -f /data/system.configured ]]; then
  touch /data/system.configured
  # also create the network.configured file because we have network
  # TODO: Make a ping check here
  touch /data/network.configured
fi

# source ${PROJECT_ROOT}/scripts/install/activate.sh
# busybox httpd -p 8088 -h ${PROJECT_ROOT}/data/images/
if [[ ($DEBUGMODE == "true") ]]; then
  /bin/bash
fi

# Remove the restart_mdns for now since it doesn't always work fully
# python3.6 scripts/network/restart_mdns.py

python3.6 manage.py runserver 0.0.0.0:80 & python3.6 scripts/platform/rpi_button_handler.py
