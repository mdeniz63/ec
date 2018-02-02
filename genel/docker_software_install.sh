# For runing commands from internet
# source <(curl -s https://raw.githubusercontent.com/mdeniz63/ec/master/install.sh);
#!/bin/bash
echo "Run as root user on Centos 7"


# Step 1
# disable dnsmasq service which is advised from docker
systemctl disable dnsmasq

# Step 2
# Install docker ce with Yum
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce

# Step 3
# Start and enable docker
systemctl start docker
systemctl enable docker

# Step 4
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
