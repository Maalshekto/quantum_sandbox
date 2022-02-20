#!/bin/bash
echo Installing Python
sleep 30
sudo apt-get update
sudo apt-get install -y python3-pip
sudo apt-get install -y nginx
sudo apt-get install -y expect
sudo pip3 install qiskit
cd /tmp
sudo curl -O https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh
sudo bash Anaconda3-2021.11-Linux-x86_64.sh -b -p /opt/conda
echo \#Custom configurations >> ~/.bashrc
echo export PATH=/opt/conda/bin:$PATH >> ~/.bashrc