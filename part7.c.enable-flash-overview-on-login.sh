#!/bin/sh

echo -e "\e[0;32m Enable quick overview of vicidial ServiceS once everytime when root user Login \e[0m"
sleep 2

cd /usr/src

tee -a ~/.bashrc <<EOF

# Commands
/usr/share/astguiclient/ADMIN_keepalive_ALL.pl --cu3way
/usr/bin/systemctl status httpd --no-pager
/usr/bin/systemctl status firewalld --no-pager
/usr/bin/screen -ls
/usr/sbin/dahdi_cfg -v
/usr/sbin/asterisk -V
EOF

