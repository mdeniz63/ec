# For runing commands from internet
# source <(curl -s https://raw.githubusercontent.com/mdeniz63/ec/master/install.sh);

#!/bin/bash
echo "Run as root user on Centos 7"

# disable dnsmasq service which is advised from docker
systemctl disable dnsmasq

# Install docker ce with Yum
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce

# Add docker config file /etc/docker/deamon.json
mkdir -p /home/ec_data
mkdir -p /etc/docker
cd /etc/docker/
curl -O https://raw.githubusercontent.com/mdeniz63/ec/master/daemon.json

# Start and enable docker
systemctl start docker
systemctl enable docker

# Create docker volumes
docker volume create files
docker volume create nitro

# Pull docker images from docker hub
image_name=mdeniz63/ec
container_name=ec
docker pull $image_name

# Run image and create container with systemd services
docker run --privileged --name $container_name -v files:/ARSIV -v nitro:/nitro/ -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:8181 -p 5432:5432 -d $image_name

# Add Systemd service and enable
cat > /usr/lib/systemd/system/ec.service << EOF1

[Unit]
Description=Enterprise Cloud
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a ec
ExecStop=/usr/bin/docker stop -t 2 ec

[Install]
WantedBy=default.target

EOF1

systemctl enable ec
