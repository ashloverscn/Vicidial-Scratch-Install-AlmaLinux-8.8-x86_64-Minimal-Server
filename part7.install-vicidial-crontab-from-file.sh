#!/bin/sh

echo -e "\e[0;32m Install crontab entry from vici-cron \e[0m"
sleep 2
cd /usr/src
\cp -r /usr/src/vici-cron /usr/src/vici-cron.original 
#wget -O /usr/src/vici-cron https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/vici-cron
crontab -l > vici-cron.original
crontab < vici-cron

