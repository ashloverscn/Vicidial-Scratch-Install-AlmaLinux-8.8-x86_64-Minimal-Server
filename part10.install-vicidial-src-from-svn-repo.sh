#!/bin/sh

yum -y install expect
echo -e "\e[0;32m Please Enter This Server IP ADDRESS \e[0m"
read serveripadd

echo "serveripadd is "$serveripadd
sleep 2

echo -e "\e[0;32m Clone vicidial from  SVN \e[0m"
sleep 2
mkdir /usr/src/astguiclient
cd /usr/src/astguiclient
svn checkout svn://svn.eflo.net/agc_2-X/trunk
cd /usr/src/astguiclient/trunk

echo -e "\e[0;32m Setup dummy DB for astguiclient \e[0m"
sleep 2
mysql -uroot -e "DROP DATABASE IF EXISTS asterisk;"
mysql -uroot -e "SHOW DATABASES;"
sleep 5
mysql -uroot -e "CREATE DATABASE asterisk DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -uroot -e "CREATE USER 'cron'@'localhost' IDENTIFIED BY '1234';"
mysql -uroot -e "GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO cron@'%' IDENTIFIED BY '1234';"
mysql -uroot -e "GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO cron@localhost IDENTIFIED BY '1234';"
mysql -uroot -e "GRANT RELOAD ON *.* TO cron@'%';"
mysql -uroot -e "GRANT RELOAD ON *.* TO cron@localhost;"
mysql -uroot -e "CREATE USER 'custom'@'localhost' IDENTIFIED BY 'custom1234';"
mysql -uroot -e "GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO custom@'%' IDENTIFIED BY 'custom1234';"
mysql -uroot -e "GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO custom@localhost IDENTIFIED BY 'custom1234';"
mysql -uroot -e "GRANT RELOAD ON *.* TO custom@'%';"
mysql -uroot -e "GRANT RELOAD ON *.* TO custom@localhost;"
mysql -uroot -e "flush privileges;"
mysql -uroot -e "SET GLOBAL connect_timeout=60;"
mysql -uroot asterisk < /usr/src/astguiclient/trunk/extras/MySQL_AST_CREATE_tables.sql
mysql -uroot asterisk < /usr/src/astguiclient/trunk/extras/first_server_install.sql
mysql -uroot -e "use asterisk ; update servers set asterisk_version='16.30.0';"
mysql -uroot -e "use asterisk ; show tables;"
sleep 5

echo -e "\e[0;32m Configure astguiclient.conf \e[0m"
sleep 2
cd /usr/src/
\cp -r /etc/astguiclient.conf /etc/astguiclient.conf.original
echo "" > /etc/astguiclient.conf
#wget -O /usr/src/astguiclient.conf https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/astguiclient.conf
\cp -r ./astguiclient.conf /etc/astguiclient.conf

sed -i 's/VARserver_ip => .*/VARserver_ip => $serveripadd/' /etc/astguiclient.conf

echo -e "\e[0;32m Install vicidial \e[0m"
sleep 2
cd /usr/src/astguiclient/trunk
perl install.pl

echo -e "\e[0;32m Populate area codes \e[0m"
sleep 2
/usr/share/astguiclient/ADMIN_area_code_populate.pl
echo -e "\e[0;32m Update server ip \e[0m"
sleep 2
/usr/share/astguiclient/ADMIN_update_server_ip.pl --old-server_ip=10.10.10.15
/usr/share/astguiclient/ADMIN_audio_store_sync.pl --upload


