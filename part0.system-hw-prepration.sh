#!/bin/sh

echo -e "\e[0;32m Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server \e[0m"
echo -e "\e[0;32m Part0 System-HW-Prepration \e[0m"
sleep 5

export LC_ALL=C

# part 0
echo -e "\e[0;32m Install NetworkManager Cli Gui \e[0m"
sleep 2
yum -y install NetworkManager NetworkManager-tui 

#echo -e "\e[0;32m Disable ipv6 network \e[0m"
#sleep 2
#disable ipv6 system-wide 
#echo "" > /etc/sysctl.conf
#if already present then dont add the lines 
#sed -i -e '$a\
#\
#net.ipv6.conf.all.disable_ipv6 = 1 \
#net.ipv6.conf.default.disable_ipv6 = 1 \
#net.ipv6.conf.enp0s3.disable_ipv6 = 1 \
#' /etc/sysctl.conf

systemctl restart network
service network restart

echo -e "\e[0;32m Configure vicidial firewalld with xml config files \e[0m"
sleep 2

#yum -y remove firewalld
yum -y install firewalld
systemctl enable firewalld

rm -rf /etc/firewalld.bak/
rm -rf /usr/lib/firewalld.bak/
mv /etc/firewalld/ /etc/firewalld.bak/
mv /usr/lib/firewalld/ /usr/lib/firewalld.bak/
mkdir /etc/firewalld/
mkdir /usr/lib/firewalld/
\cp -r /usr/src/firewalld/etc-firewalld/* /etc/firewalld/ 
\cp -r /usr/src/firewalld/usr-lib-firewalld/* /usr/lib/firewalld/

systemctl start firewalld
systemctl status firewalld
firewall-cmd --reload

echo -e "\e[0;32m Enable grub verbose boot \e[0m"
sleep 2

sed -i 's/rhgb//g' /etc/default/grub
sed -i 's/quiet//g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

echo -e "\e[0;32m Enable PrintMotd file to show terminal welcome msg \e[0m"
sleep 2

/usr/src/./enable-PrintMotd.sh

#reboot
