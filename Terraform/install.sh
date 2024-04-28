#!/bin/bash

# Install needed dependencies
yum update -y
yum install -y yum-utils device-mapper-persistent-data lvm2 python3-pip git docker

# Start Docker
systemctl start docker
systemctl enable docker

# Download Docker Compose binary
if [ ! -f "/usr/local/bin/docker-compose" ]; then
    wget -q https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -O /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Download repo
git clone https://github.com/Daxin18/Tic-Tac-Toe.git /home/ec2-user/game

# Run docker-compose up
sudo docker-compose -f /home/ec2-user/game/docker-compose.yml up -d