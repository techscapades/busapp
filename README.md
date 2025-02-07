On host:
wget https://raw.githubusercontent.com/techscapades/busapp/main/docker_install.sh
docker pull ubuntu
sudo mkdir /home/$USER/AppExt && sudo wget -O /home/$USER/AppExt/app_installer.sh https://raw.githubusercontent.com/techscapades/busapp/main/app_installer.sh
docker run -t -d --name devbustimingcont --network host -v /home/$USER/AppExt:/AppExt ubuntu
docker exec -it devbustimingcont /bin/bash
bash /AppExt/app_installer.sh
