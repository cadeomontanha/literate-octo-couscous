#!/bin/bash -eux

#Instalando Ansible na Maquina
#sudo cloud-init status --wait
sudo apt-get update -y && sudo apt-get install python python3 python3-pip -y && sudo pip3 install ansible
