#!/bin/bash

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
COUNT=0
while ! pg_isready -h "${DB_SERVICE}" -p 5435 -U "${DB_USER}"; do
  sleep 2
  COUNT=$((COUNT+1))
  if [ "$COUNT" -ge 30 ]; then
    echo "Timeout waiting for PostgreSQL. Exiting..."
    exit 1
  fi
done

echo "PostgreSQL is ready. Initializing database..."

# Initialize the database
odoo -d "${DB_NAME}" -i base --db_host="${DB_SERVICE}" --db_user="${DB_USER}" --db_password="${DB_PASSWORD}" --without-demo=all --stop-after-init

# Start Odoo
echo "Starting Odoo..."
exec odoo
