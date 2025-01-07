#!/bin/bash

# Initialize the database with the base module
echo "Initializing database with the base module..."
odoo -d ${DB_NAME} -i base --db_host=${DB_SERVICE} --db_user=${DB_USER} --db_password=${DB_PASSWORD} --without-demo=all

# Run initialization command with --stop-after-init
echo "Running initialization command with --stop-after-init..."
odoo -d ${DB_NAME} --init=base --stop-after-init

# Start Odoo after initialization
echo "Starting Odoo..."
exec odoo
