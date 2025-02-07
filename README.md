wget -qO- https://raw.githubusercontent.com/techscapades/busapp/main/docker_install.sh | sudo bash

docker pull ubuntu

sudo mkdir /home/$USER/AppExt && sudo wget -O /home/$USER/AppExt/app_installer.sh https://raw.githubusercontent.com/techscapades/busapp/main/app_installer.sh

docker run -t -d --name devbustimingcont --network host -v /home/$USER/AppExt:/AppExt ubuntu

docker exec -it devbustimingcont /bin/bash

bash /AppExt/app_installer.sh

**After installation**
test the container and navigate to {hostname}.local:17700/ui with this command:

docker start devbustimingcont && docker exec devbustimingcont bash -c "bash /etc/busapp/startup.sh"

**autostart container with systemd**

sudo nano /etc/systemd/system/devbustimingcont.service

(in the file)

[Unit]

Description=Start devbustimingcont Docker container and run startup script

After=docker.service

Requires=docker.service

[Service]

Type=oneshot

ExecStartPre=/usr/bin/docker start devbustimingcont

ExecStart=/usr/bin/docker exec devbustimingcont bash -c "bash /etc/busapp/startup.sh"

RemainAfterExit=true

[Install]

WantedBy=multi-user.target

(exit the file)

sudo systemctl daemon-reload

sudo systemctl enable devbustimingcont.service

sudo systemctl start devbustimingcont.service

sudo systemctl status devbustimingcont.service
