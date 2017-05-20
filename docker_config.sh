# create docker config file for change docker root directory

#!/bin/bash

mkdir -p /home/ec_data
mkdir -p /etc/docker
cd /etc/docker/

cat > daemon.json << EOF1
{
    "graph": "/home/ec_data"
}
EOF1
