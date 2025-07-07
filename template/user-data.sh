#!/bin/bash
cd /home/ubuntu
yes | sudo apt update
yes | sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
git clone https://github.com/bibinpanicker07/python-mysql-db-proj.git
cd python-mysql-db-proj
sudo docker build -t myapp:latest .
sudo docker run -p 5000:5000 -d myapp:latest
