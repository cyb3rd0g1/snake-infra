#!/bin/bash
echo "installing dependencies"
yum update -y
yum install git docker -y 
service docker start
usermod -a -G docker ec2-user

echo "getting docker-compose"
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
/usr/local/bin/docker-compose version

echo "cloning repos..."
cd /home/ec2-user
git clone https://github.com/149alexniu149/snake-client.git
git clone https://github.com/149alexniu149/snake-server.git

echo "starting services"
cd snake-client  && /usr/local/bin/docker-compose up -d
cd ..
cd snake-server && /usr/local/bin/docker-compose up -d