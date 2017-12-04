#!/bin/bash

version=`cat VERSION`
echo "version: $version"

# docker hub username
USERNAME=mdeniz63
# image name
IMAGE_NAME=ec

docker tag $IMAGE_NAME $USERNAME/$IMAGE_NAME:$version
docker tag $IMAGE_NAME $USERNAME/$IMAGE_NAME:latest

#login
docker login -u $USERNAME

# push it
docker push $USERNAME/$IMAGE_NAME:latest
docker push $USERNAME/$IMAGE_NAME:$version
