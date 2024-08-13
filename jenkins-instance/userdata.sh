#!/bin/bash

sudo yum update 
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo dnf install java-17-amazon-corretto -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

sudo yum install git docker -y
sudo systemctl start docker

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
sudo unzip awscliv2.zip 
sudo ./aws/install  
sudo rm awscliv2.zip

sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"  
sudo chmod +x ./kubectl  
sudo mv ./kubectl /usr/local/bin/kubectl

sudo curl -LO "https://releases.hashicorp.com/terraform/1.9.4/terraform_1.9.4_linux_amd64.zip"  
sudo unzip terraform_1.9.4_linux_amd64.zip  
sudo mv terraform /usr/local/bin/  
sudo rm terraform_1.9.4_linux_amd64.zip

sudo wget https://get.helm.sh/helm-v3.15.3-linux-amd64.tar.gz
sudo tar -zxvf helm-v3.15.3-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
