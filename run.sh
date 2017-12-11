#!/bin/bash

image_name=mdeniz63/ec:latest
container_name=ec

# Mount for Volume
echo -e "\n"
echo "What is the path which you want to store files?"
read -p "Path :" FilesMountPoint

# Login Docker Hub
docker login -u mdeniz63

# Create docker volumes
docker volume create nitro

# Run image and create container with systemd services
docker run --privileged --name $container_name -v $FilesMountPoint:/ARSIV -v nitro:/nitro/ -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:8181 -p 5432:5432 -d $image_name

# Change owner of FilesMountPoint in container /ARSIV
docker exec -it ec chown -R nitro:nitro /ARSIV
