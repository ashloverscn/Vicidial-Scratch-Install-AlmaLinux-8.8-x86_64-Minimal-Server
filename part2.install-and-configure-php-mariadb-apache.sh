#!/bin/sh

echo -e "\e[0;32m Install epel-release-latest-7 repo and Install RemiRepo PHP7 \e[0m"
sleep 2

#yum -y remove https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

#yum -y remove http://rpms.remirepo.net/enterprise/remi-release-7.rpm

#yum -y remove yum-utils

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

yum -y install yum-utils

yum-config-manager --enable remi-php74

echo -e "\e[0;32m Configure fail2ban for vicidial with jail.local file \e[0m"
sleep 2

/usr/src/./install-fail2ban.sh

echo -e "\e[0;32m Add MariaDB Repo \e[0m"
sleep 2

cd /usr/src
\cp -r /etc/yum.repos.d/MariaDB.repo /etc/yum.repos.d/MariaDB.repo.original
touch /etc/yum.repos.d/MariaDB.repo
echo "" > /etc/yum.repos.d/MariaDB.repo
#wget -O /usr/src/MariaDB.repo https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/MariaDB.repo
\cp -r ./MariaDB.repo /etc/yum.repos.d/MariaDB.repo
#\cp -r /usr/src/MariaDB.repo /etc/yum.repos.d/MariaDB.repo


echo -e "\e[0;32m Install Compiler\Build Tools \e[0m"
sleep 2

#yum -y remove make patch gcc perl-Term-ReadLine-Gnu gcc-c++ subversion php mod_ssl php-devel php-gd gd-devel php-mbstring php-mcrypt php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc php-opcache curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel httpd libpcap libpcap-devel libnet ncurses ncurses-devel screen mysql-devel ntp mutt glibc.i686 wget nano unzip sipsak sox libss7* libopen* openssl libsrtp libsrtp-devel unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel libedit libedit-devel htop iftop

#yum -y remove make make patch gcc perl-Term-ReadLine-Gnu gcc-c++ subversion php mod_ssl php-devel php-gd gd-devel php-mbstring php-mcrypt php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel httpd libpcap libpcap-devel libnet ncurses ncurses-devel screen mysql-devel ntp mutt glibc.i686 wget nano unzip sipsak sox libss7* libopen* openssl libsrtp libsrtp-devel unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel libedit libedit-devel

yum -y install make patch gcc perl-Term-ReadLine-Gnu gcc-c++ subversion php mod_ssl php-devel php-gd gd-devel php-mbstring php-mcrypt php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc php-opcache curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel httpd libpcap libpcap-devel libnet ncurses ncurses-devel screen mysql-devel ntp mutt glibc.i686 wget nano unzip sipsak sox libss7* libopen* openssl libsrtp libsrtp-devel unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel libedit libedit-devel htop iftop

yum -y install make patch gcc perl-Term-ReadLine-Gnu gcc-c++ subversion php mod_ssl php-devel php-gd gd-devel php-mbstring php-mcrypt php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel httpd libpcap libpcap-devel libnet ncurses ncurses-devel screen mysql-devel ntp mutt glibc.i686 wget nano unzip sipsak sox libss7* libopen* openssl libsrtp libsrtp-devel unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel libedit libedit-devel

yum -y update

echo -e "\e[0;32m Install and configure MariaDB\SQL \e[0m"
sleep 2

#yum -y remove sqlite-devel

#yum -y remove mariadb-server mariadb MariaDB-compat

yum -y install sqlite-devel

yum -y install mariadb-server mariadb 

yum -y install sqlite-devel

yum -y install mariadb-server mariadb

yum -y update

echo -e "\e[0;32m Create mysql Log files \e[0m"
sleep 2

mkdir /var/log/mysqld
mv /var/log/mysqld.log /var/log/mysqld/mysqld.log
touch /var/log/mysqld/slow-queries.log
chown -R mysql:mysql /var/log/mysqld


echo -e "\e[0;32m Configure mariadb mysql my.cnf file \e[0m"
sleep 2

cd /usr/src
\cp -r /etc/my.cnf /etc/my.cnf.original
echo "" > /etc/my.cnf
#wget -O /usr/src/my.cnf https://raw.githubusercontent.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/main/my.cnf
\cp -r ./my.cnf /etc/my.cnf
#\cp -r /usr/src/my.cnf /etc/my.cnf 

echo -e "\e[0;32m Configure Httpd\Apache2 httpd.conf file and Load Self-Signed Certificates \e[0m"
sleep 2

cd /usr/src/
\cp -r /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.original
echo "" > /etc/httpd/conf/httpd.conf
#wget -O /usr/src/httpd.conf https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/httpd.conf
\cp -r ./httpd.conf /etc/httpd/conf/httpd.conf
#\cp -r /usr/src/httpd.conf /etc/httpd/conf/httpd.conf

cd /usr/src
rm -rf /etc/httpd/ssl.crt/vicibox.crt
rm -rf /etc/httpd/ssl.key/vicibox.key
mkdir /etc/httpd/ssl.crt
mkdir /etc/httpd/ssl.key
\cp -r ./vicibox.crt /etc/httpd/ssl.crt/vicibox.crt
\cp -r ./vicibox.key /etc/httpd/ssl.key/vicibox.key

echo -e "\e[0;32m Configure Httpd\Apache2 https-ssl conf.d files \e[0m"
sleep 2

cd /usr/src
\cp -r /etc/httpd/conf.d/0000-default.conf /etc/httpd/conf.d/0000-default.conf.original
\cp -r /etc/httpd/conf.d/0000-default-ssl.conf /etc/httpd/conf.d/0000-default-ssl.conf.original
echo "" > /etc/httpd/conf.d/0000-default.conf
echo "" > /etc/httpd/conf.d/0000-default-ssl.conf
#wget -O /usr/src/httpd.conf https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/0000-default.conf
#wget -O /usr/src/httpd.conf https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/0000-default-ssl.conf
\cp -r ./0000-default.conf /etc/httpd/conf.d/0000-default.conf
\cp -r ./0000-default-ssl.conf /etc/httpd/conf.d/0000-default-ssl.conf
#\cp -r /usr/src/0000-default.conf /etc/httpd/conf.d/0000-default.conf
#\cp -r /usr/src/0000-default-ssl.conf /etc/httpd/conf.d/0000-default-ssl.conf
mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.bak

echo -e "\e[0;32m Please Enter Redirect permanent address for https \e[0m"
sleep 2
read serveripadd

sed -i "s/Redirect permanent \/ https:\/\/.*/Redirect permanent \/ https:\/\/$serveripadd\//g" /etc/httpd/conf.d/0000-default.conf

echo -e "\e[0;32m Configure PHP PHP.ini file \e[0m"
sleep 2

cd /usr/src
\cp -r /etc/php.ini /etc/php.ini.original
echo "" > /etc/php.ini
#wget -O /usr/src/php.ini https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/php.ini
\cp -r ./php.ini /etc/php.ini
#\cp -r /usr/src/php.ini /etc/php.ini

echo -e "\e[0;32m create index.html in webroot for redirecting to welcome.php \e[0m"
sleep 2

touch /var/www/html/index.html
echo "" > /var/www/html/index.html
sed -i -e '$a\
<META HTTP-EQUIV=REFRESH CONTENT="1; URL=/vicidial/welcome.php"> \
Please Hold while I redirect you! \
' /var/www/html/index.html

echo -e "\e[0;32m Enable and start Httpd and MariaDb services \e[0m"
sleep 2

systemctl enable httpd.service
systemctl enable mariadb.service
systemctl start httpd.service
systemctl start mariadb.service
systemctl status mariadb.service
systemctl status httpd.service

