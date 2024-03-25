#!/bin/bash

# Check if the container name/ID is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <container_name_or_id>"
    exit 1
fi

# Assign the container name/ID to a variable
CONTAINER_NAME_OR_ID=$1

# Specify the file path inside the container
FILE_PATH="/opt/tak/certs/files/ca.pem"

# Define the destination directory on the host. Change it as needed.
DEST_DIR="./export_certs"
mkdir -p "$DEST_DIR"

# Export the file from the specified container
docker cp "$CONTAINER_NAME_OR_ID":"$FILE_PATH" "$DEST_DIR"

# Check if the file was successfully copied
if [ -f "$DEST_DIR/ca.pem" ]; then
    echo "File ca.pem has been successfully export to $DEST_DIR"
else
    echo "Failed to export the file from the container. Please check if the container is running and the file exists."
fi
