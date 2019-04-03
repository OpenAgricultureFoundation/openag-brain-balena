#!/bin/bash

cd /opt/openagbrain

DB_LOCATION="${STORAGE_LOCATION:-data}/db"

echo "DB LOCATION: ${DB_LOCATION}"

if [[ ! -d "${DB_LOCATION}" ]]; then
    echo "Running First Time DB Setup"
    # Make sure the directory for the database is created
    mkdir -p ${DB_LOCATION}

    # Migrate/Create DB
    python3.6 manage.py migrate

    # Create the users
    echo "from django.contrib.auth.models import User; User.objects.filter(email='openag@openag.edu').delete(); User.objects.create_superuser('openag', 'openag@openag.edu', 'openag')" | python3.6 manage.py shell
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('backdoor', 'openag@openag.edu', 'B@ckd00r')" | python3.6 manage.py shell

    # Collect the static files
    # python3.6 manage.py collectstatic --clear --link --noinput

else
    # We should run the migrate anyway, just in case data model has changed.
    python3.6 manage.py migrate
fi