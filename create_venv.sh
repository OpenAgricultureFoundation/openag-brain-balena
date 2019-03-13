#!/usr/bin/env bash
echo "Current Python: "
echo `which python3.6`
python3.6 -m venv --system-site-packages  /opt/openagbrain/venv
source /opt/openagbrain/venv/bin/activate
echo "Current Python: "
echo `which python3.6`

pip3.6 install -r /opt/openagbrain/requirements.txt
deactivate