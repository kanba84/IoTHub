#!/bin/bash
######################################################
# NOTE: custom_data in terraform is executed as root, 
# so sudo is not needed in this script.
######################################################
apt update
apt install -y build-essential
cd /tmp
curl https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > ./microsoft-prod.list
cp ./microsoft-prod.list /etc/apt/sources.list.d/
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
cp ./microsoft.gpg /etc/apt/trusted.gpg.d/

apt update
apt install -y moby-engine
apt install -y iotedge
