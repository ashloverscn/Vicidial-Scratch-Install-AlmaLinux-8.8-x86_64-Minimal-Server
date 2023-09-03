#!/bin/sh

echo -e "\e[0;32m Install rc.local entry for vicidial services startup \e[0m"
sleep 2
cd /usr/src
\cp -r /etc/rc.d/rc.local /etc/rc.d/rc.local.original 
#wget -O /usr/src/rc.local https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/rc.local
\cp -r /usr/src/rc.local /etc/rc.d/rc.local

chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
systemctl start rc-local

