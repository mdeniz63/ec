#!/bin/bash
# Stop all containers
docker stop $(docker ps -a -q)
# Delete all containers
docker rm -v $(docker ps -a -q)
# Delete all images
docker rmi $(docker images -q)
#Remove all dangling images. If -a is specified, will also remove all images not referenced by any container.
docker system prune -a -f
