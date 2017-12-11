# This script build new nitro.tar from running container
# First clear logs from container
docker exec -it ec /bin/bash -c /nitro/script/createDeployPackage.sh

# Copy nitro.tar
docker cp ec:/nitro.tar.gz .

# Delete nitro.tar
docker exec ec rm -rf /nitro.tar.gz
