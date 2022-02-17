#!/bin/bash

echo "### Adding hosts..."
echo "192.168.95.100 docker.hw1.ivo docker" >> /etc/hosts
  
echo "### Removing old Docker instance if there are any..."
removalResult=$(sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine)
echo $removalResult
  
echo "### Adding Docker repository..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  
echo "### Installing Docker..."
sudo dnf install -y docker-ce docker-ce-cli containerd.io
  
echo "### Enable and Start Docker deamon and configuring it to start on boot..."
sudo systemctl enable docker
#sudo systemctl enable containerd.service
sudo systemctl start docker

echo "### Check Docker deamon status..."
sudo systemctl status docker
echo "### INFO:: Installed Docker Version: ..."
sudo docker version
echo "### INFO:: Installed Docker System Info: ..."
sudo docker system info
  
echo "### Adding sudo user to the Docker group, to be able to work with docker without the need to use always sudo..."
sudo usermod -aG docker $USER
  
echo "### Firewall - open port 8080 ..."
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
  
#echo "### Changing '~/.docker/' directory ownership and permissions..."
#sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
#sudo chmod g+rwx "$HOME/.docker" -R

echo "## Creating 'env' folder and copy files into it..."
#mkdir web && cp /resources/index.html /home/$USER/web
mkdir env && cp -r /resources/. /home/vagrant/env

echo "## Pulling Docker image 'centos'..."
docker image pull centos:centos7
echo "## Checking Docker images..."
docker image ls
echo "## Building docker image..."
cd env && docker image build -t dockerhw:v0.0.1 .
echo "## Check docker containers..."
docker container ls -a
echo "## Running created container..."
docker container run -dit -p 8080:80 dockerhw:v0.0.1
echo "## Check running docker container/s..."
docker container ls












