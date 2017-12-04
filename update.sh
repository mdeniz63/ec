# Pull docker images from docker hub
image_name=mdeniz63/ec
container_name=ec
docker pull $image_name

# Mount for Volume
echo -e "\n"
echo "What is the path which you want to store files?"
read -p "Path : " FilesMountPoint

# Run image and create container with systemd services
docker run --privileged --name $container_name -v $FilesMountPoint:/ARSIV -v nitro:/nitro/ -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:8181 -p 5432:5432 -d $image_name
