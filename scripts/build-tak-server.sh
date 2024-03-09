#!/bin/bash

# Define the image name
IMAGE_NAME="tak-server-builder"

# Define the container name
CONTAINER_NAME="TAKServer"

# Define the directory path inside the container
CONTAINER_DIR_PATH="/build/Server/src/takserver-package/build/distributions"

# Define the host directory to copy the directory to
HOST_DIR="./distributions"

RELEASE_VERSION="5.0-RELEASE-30"
# RELEASE_VERSION="4.10-RELEASE-68"

# Build the Docker image
# docker build -t $IMAGE_NAME -f ./docker/amd64/Dockerfile.takserver-build ..
docker build -t $IMAGE_NAME:$RELEASE_VERSION --build-arg RELEASE_VERSION=$RELEASE_VERSION -f ./docker/amd64/Dockerfile.takserver-build .

# Check if the container already exists and remove it
if [ "$(docker ps -aq -f name=^${CONTAINER_NAME}$)" ]; then
    echo "Removing existing container..."
    docker rm $CONTAINER_NAME
fi

# Create the Docker container
docker create --name $CONTAINER_NAME $IMAGE_NAME:$RELEASE_VERSION

# Copy the directory from the container to the host
docker cp $CONTAINER_NAME:$CONTAINER_DIR_PATH $HOST_DIR

# Remove the container after copying the directory
docker rm -f $CONTAINER_NAME

# Remove the Docker image
docker rmi -f $IMAGE_NAME:$RELEASE_VERSION

mv ./distributions/*.zip ./
rm -r ./distributions

echo "Directory copied to $HOST_DIR and image $IMAGE_NAME:$RELEASE_VERSION deleted"

