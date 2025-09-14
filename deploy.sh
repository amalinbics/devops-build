#!/bin/bash
# Stop and remove old container if running
set -e
cd /tmp/devops-build || exit 1
CONTAINER_NAME=$1
IMAGE_NAME=$2
DOCKER_USERNAME=$3
DOCKER_PASSWORD=$4


echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping old container..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Run new container
echo "Deploying new container..."
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME:latest

echo "Deployment complete. App is running on port 80."
