#!/bin/bash

yum update -y
yum install git docker -y 
service docker start
usermod -a -G docker ec2-user

curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
/usr/local/bin/docker-compose version

cd /home/ec2-user
git clone https://github.com/149alexniu149/snake-client.git
git clone https://github.com/149alexniu149/snake-server.git

cd snake-client  && /usr/local/bin/docker-compose up -d
cd ..
cd snake-server && /usr/local/bin/docker-compose up -d