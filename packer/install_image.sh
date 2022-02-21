#!/bin/bash
echo Installing Python
sleep 30
sudo apt-get update
sudo apt-get install -y python3-pip
sudo apt-get install -y nginx
sudo apt-get install -y expect

cd /tmp
sudo curl -O https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh
sudo bash Anaconda3-2021.11-Linux-x86_64.sh -b -p /opt/conda
echo \#Custom configurations >> ~/.bashrc
echo export PATH=/opt/conda/bin:$PATH >> ~/.bashrc

/opt/conda/bin/pip3 install qiskit 
/opt/conda/bin/pip3 install pylatexenc

# Configure Nginx
sudo cp /tmp/nginx_jupyter.conf /etc/nginx/sites-available/
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/nginx_jupyter.conf /etc/nginx/sites-enabled/nginx_jupyter.conf

# Configure jupyter
export PATH=/opt/conda/bin:$PATH
jupyter notebook --generate-config
cp -f /tmp/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py 
