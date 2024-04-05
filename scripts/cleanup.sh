#!/bin/bash

# Check if we are NOT currently running as root
if [[ $EUID -ne 0 ]]; then
    echo "Attempting to rerun script with sudo..."
    # Invoke this script again with sudo
    sudo "$0" "$@"
    exit $?
fi

# Your script's commands go here
echo "Running with necessary privileges..."

DOCKER_COMPOSE="docker-compose"

if ! command -v docker-compose
then
        DOCKER_COMPOSE="docker compose"
        echo "Docker compose command set to new style $DOCKER_COMPOSE"
fi

$DOCKER_COMPOSE down

# docker volume rm --force tak-server_db_data
rm -rf tak
rm -rf /tmp/takserver

# Comment me out to save yourself rebuilding........
docker image rm tak-server-configurator-db --force
docker image rm tak-server-configurator-tak --force
docker volume rm tak-server-configurator_db_data --force
