#!/usr/bin/env bash
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo "Setting up DB"
${PROJECT_ROOT}/setup_django_db.sh

## IOT SETTINGS
export IOT_PRIVATE_KEY=/data/registration/rsa_private.pem
export CA_CERTS=/data/registration/roots.pem
export GCLOUD_PROJECT=openag-v1
export GCLOUD_REGION=us-central1
export GCLOUD_DEV_REG=device-registry

export RUNTIME_MODE="DEVELOPMENT"
# export LOG_LEVEL="DEBUG"

source ${PROJECT_ROOT}/venv/bin/activate

echo "Setting ENV vars"
source ${PROJECT_ROOT}/set_env_vars.sh

# source ${PROJECT_ROOT}/scripts/install/activate.sh
# busybox httpd -p 8088 -h ${PROJECT_ROOT}/data/images/
python3.6 manage.py runserver 0.0.0.0:80
