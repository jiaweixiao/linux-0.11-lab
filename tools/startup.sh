#!/bin/bash

mkdir -p /var/run/sshd

# create an ubuntu user
UNIX_PASS=`pwgen -c -n -1 10`
VNC_PASS=`pwgen -c -n -1 10`
echo "Username: ubuntu Password: $UNIX_PASS VNC-Password: $VNC_PASS"

id -u ubuntu &>/dev/null || useradd --create-home --shell /bin/bash --user-group --groups adm,sudo ubuntu

sudo mkdir /home/ubuntu/Desktop/
sudo cp /linux-lab.desktop /home/ubuntu/Desktop/
sudo chown ubuntu:ubuntu -R /home/ubuntu/

sudo -u ubuntu mkdir /home/ubuntu/.vnc/
sudo -u ubuntu x11vnc -storepasswd $VNC_PASS /home/ubuntu/.vnc/passwd

echo "ubuntu:$UNIX_PASS" | chpasswd
sudo -u ubuntu -i bash -c "mkdir -p /home/ubuntu/.config/pcmanfm/LXDE/ \
    && cp /usr/share/doro-lxde-wallpapers/desktop-items-0.conf /home/ubuntu/.config/pcmanfm/LXDE/"

cd /web && ./run.py > /var/log/web.log 2>&1 &
nginx -c /etc/nginx/nginx.conf

if [ -f /bin/tini ]; then
	exec /bin/tini -- /usr/bin/supervisord -n
else
	exec /usr/bin/supervisord -n
fi