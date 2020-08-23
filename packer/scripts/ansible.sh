#!/bin/bash -eux

#Instalando Ansible na Maquina
sudo cloud-init status --wait
sudo apt-get update -y && sudo apt-get install python python-pip -y && sudo pip install ansible
