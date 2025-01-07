#!/bin/bash

# Navigate to the directory where the Makefile is located (optional)
cd "$(dirname "$0")"

# Run the 'make up' command to start the containers
echo "Starting containers..."
make up

# Run the 'make init-db' command to initialize the database
echo "Initializing database with the base module..."
make init-db
