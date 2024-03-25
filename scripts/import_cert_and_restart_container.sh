#!/bin/bash

# Check if all necessary arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <container_name_or_id> <cert_file_on_host> <alias_for_cert>"
    exit 1
fi

# Assign arguments to variables
CONTAINER_NAME_OR_ID=$1
CERT_FILE_ON_HOST=$2
ALIAS=$3
CONTAINER_CERT_PATH="./tmp/cert.pem"  # Fixed path inside the container

# Copy the certificate file into the specified container
docker cp "$CERT_FILE_ON_HOST" "$CONTAINER_NAME_OR_ID":"$CONTAINER_CERT_PATH"

# Run the keytool command inside the container to import the certificate
docker exec "$CONTAINER_NAME_OR_ID" keytool -import -trustcacerts -file "$CONTAINER_CERT_PATH" -keystore /opt/tak/certs/files/fed-truststore.jks -alias "$ALIAS" -storepass atakatak -noprompt

# Check if the certificate was successfully imported
if [ $? -eq 0 ]; then
    echo "Certificate has been successfully imported into the container."
    
    # Restart the container to apply changes
    docker restart "$CONTAINER_NAME_OR_ID"
    echo "Container $CONTAINER_NAME_OR_ID has been restarted."
else
    echo "Failed to import the certificate into the container."
fi