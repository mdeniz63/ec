#!/bin/bash

# Login Docker Hub
docker login -u mdeniz63

# Pull docker images from docker hub
image_name=mdeniz63/ec
container_name=ec
docker pull $image_name

