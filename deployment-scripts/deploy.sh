#!/bin/bash
IMAGE_NAME="<IMAGE_NAME>"
IMAGE_TAG="<IMAGE_TAG>"
CONTAINER_NAME="<CONTAINER_NAME>"

# Stop and remove old container if running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping old container..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Run new container
echo "Deploying new container..."
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME:$IMAGE_TAG

echo "Deployment complete. App is running on port 80."
