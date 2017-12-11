#!/bin/bash

echo "Stop container..."
docker stop ec

echo "System prune..."
docker system prune

#echo "Creatig volumes..."
docker volume create nitro

if [ $# -eq 0 ]
  then
   	echo "Docker building with cache..."
	docker build -t ec .
  else
	echo "Docker building without cache..."
	docker build --rm --no-cache -t ec .
fi


echo "Run in a new container..."
docker run --privileged --name ec -v /ARSIV:/ARSIV -v nitro:/nitro/ -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:8181 -p 5432:5432 -d ec

echo "Get console..."
docker exec -i -t ec /bin/bash
