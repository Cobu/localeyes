#!/bin/bash

# Usage: ./deploy.sh [host]
# production  107.20.170.68
# host="${1:-107.20.170.68}"
#host="${1:-ip.address.goes.here}"

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${host#*@}" 2> /dev/null

tar cj . | ssh -i ~/.ssh/dsudol_rsa -o 'StrictHostKeyChecking no' "ubuntu@$host" '
sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj &&
sudo bash install.sh'