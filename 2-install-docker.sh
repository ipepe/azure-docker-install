#!/bin/bash

set -e

echo Installing docker...
sudo apt-get update
sudo apt install docker.io
sudo systemctl start docker

#status of docker
echo You can check status of docker service with:
echo sudo systemctl status docker

echo "Adding azureuser to docker group. You have to relog to make this work"
sudo usermod -aG docker azureuser

echo "Installing docker-compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Changing storage driver to devicemapper"
sudo systemctl stop docker
sudo rm -rf /var/lib/docker
sudo sed -i -e '/^ExecStart=/ s/$/ --storage-driver=overlay2/' /lib/systemd/system/docker.service

echo "Reloading services"
sudo systemctl daemon-reload
sudo service docker restart
sudo systemctl restart docker

echo "Current storage driver is: (be worried if its not overlay2)"
sudo docker info | grep Storage\ Driver
