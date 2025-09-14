#!/bin/bash
# Build Docker image
set -e
IMAGE_NAME=$1
IMAGE_TAG=$2
DOCKER_USERNAME=$DOCKER_USER
DOCKER_PASSWORD=$DOCKER_PASS
cd /tmp/devops-build || exit 1
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
echo "Building Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .
docker push ${IMAGE_NAME}:${IMAGE_TAG}
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
docker push ${IMAGE_NAME}:latest
echo "Build complete: $IMAGE_NAME:$IMAGE_TAG"


