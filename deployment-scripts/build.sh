#!/bin/bash
# Build Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .
echo "Build complete: $IMAGE_NAME:$IMAGE_TAG"
