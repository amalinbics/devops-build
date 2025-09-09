#!/bin/bash
# Build Docker image
IMAGE_NAME="<IMAGE_NAME>"
IMAGE_TAG="<IMAGE_TAG>"

echo "Building Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .

echo "Build complete: $IMAGE_NAME:$IMAGE_TAG"