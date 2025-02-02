#!/bin/bash

apt-get update && apt-get upgrade -y && apt autoremove -y
DEBIAN_FRONTEND=noninteractive apt install python3 python3-pip -y
apt install nano bash build-essential git curl net-tools mosquitto mosquitto-clients openssh-server htop -y
mkdir /var/run/sshd
useradd -m -d /home/ubuntu -s /bin/bash ubuntu
echo "ubuntu:1234567890" | chpasswd
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
echo -e "\nlistener 1883\nallow_anonymous true" >> /etc/mosquitto/mosquitto.conf
yes | bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
rm -rf ~/.node-red/flows.json
wget -O ~/.node-red/settings.js https://raw.githubusercontent.com/node-red/node-red/master/packages/node_modules/node-red/settings.js
npm install -g --unsafe-perm node-red-dashboard
mkdir /etc/busapp
wget -P ~/.node-red https://raw.githubusercontent.com/techscapades/busapp/main/flows.json
wget -O /etc/busapp/busapp.py https://raw.githubusercontent.com/techscapades/busapp/main/busapp.py
wget -O /etc/busapp/requirements.txt https://raw.githubusercontent.com/techscapades/busapp/main/requirements.txt
wget -O /etc/busapp/startup.sh https://raw.githubusercontent.com/techscapades/busapp/main/startup.sh
chmod 777 /etc/busapp/startup.sh
sed -i 's/process.env.PORT || 1880/process.env.PORT || 17700/' ~/.node-red/settings.js
pip install -r /etc/busapp/requirements.txt --break-system-packages
Hostname -I
bash /etc/busapp/startup.sh
