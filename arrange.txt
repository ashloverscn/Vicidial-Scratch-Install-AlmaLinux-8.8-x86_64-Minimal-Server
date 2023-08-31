#!/bin/sh

echo "Vicidial installation AlmaLinux"

export LC_ALL=C

yum install git -y

hostnamectl set-hostname lab.go2dial.com
timedatectl set-timezone Asia/Kolkata

yum check-update
yum update -y
yum -y install epel-release
yum update -y
yum install bash-completion bash-completion-extras
yum install -y kernel
yum install -y kernel*
yum install -y kernel-*
yum -y remove kernel-debug*

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config    

reboot

yum groupinstall "Development Tools" -y

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum -y install http://rpms.remirepo.net/enterprise/remi-release-8.rpm
yum -y install yum-utils
dnf module enable php:remi-7.4 -y

dnf -y install dnf-plugins-core
dnf config-manager --set-enabled powertools

yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-opcache wget unzip make patch gcc gcc-c++ subversion php php-devel php-gd gd-devel readline-devel php-mbstring php-mcrypt php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel httpd libpcap libpcap-devel libnet ncurses ncurses-devel screen mutt glibc.i686 certbot python3-certbot-apache mod_ssl openssl-devel newt-devel libxml2-devel kernel-devel kernel-headers sqlite-devel libuuid-devel sox sendmail lame-devel htop iftop perl-File-Which php-opcache libss7 mariadb-devel libss7* libopen* 
yum -y install sqlite-devel

cd /usr/src
\cp -r /etc/php.ini /etc/php.ini.original
echo "" > /etc/php.ini
#wget -O /usr/src/php.ini https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/php.ini
\cp -r ./php.ini /etc/php.ini
#\cp -r /usr/src/php.ini /etc/php.ini

systemctl restart httpd

dnf install -y mariadb-server mariadb

dnf -y install dnf-plugins-core
dnf config-manager --set-enabled powertools


systemctl enable mariadb

cd /usr/src
\cp -r /etc/my.cnf /etc/my.cnf.original
echo "" > /etc/my.cnf
#wget -O /usr/src/my.cnf https://raw.githubusercontent.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/main/my.cnf
\cp -r ./my.cnf /etc/my.cnf
#\cp -r /usr/src/my.cnf /etc/my.cnf 

mkdir /var/log/mysqld
touch /var/log/mysqld/slow-queries.log
chown -R mysql:mysql /var/log/mysqld
systemctl restart mariadb

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

sed -i "s/Redirect permanent \/ https:\/\/.*/Redirect permanent \/ https:\/\/$serveripadd\//g" /etc/httpd/conf.d/0000-default.conf

touch /var/www/html/index.html
echo "" > /var/www/html/index.html
sed -i -e '$a\
<META HTTP-EQUIV=REFRESH CONTENT="1; URL=/vicidial/welcome.php"> \
Please Hold while I redirect you! \
' /var/www/html/index.html



systemctl enable httpd.service
systemctl enable mariadb.service
systemctl start httpd.service
systemctl restart httpd.service
systemctl start mariadb.service
systemctl restart mariadb.service
#systemctl status mariadb.service
#systemctl status httpd.service
systemctl enable asterisk.service
systemctl start asterisk.service
systemctl restart asterisk.service
modprobe dahdi
systemctl enable dahdi.service
systemctl start dahdi.service
systemctl restart dahdi.service

##################################### CPAN #########################################
yum install -y perl-CPAN perl-YAML perl-libwww-perl perl-DBI perl-DBD-MySQL perl-GD perl-Env perl-Term-ReadLine-Gnu perl-SelfLoader perl-open.noarch

yum install perl-CPAN -y
yum install perl-YAML -y
yum install perl-libwww-perl -y
yum install perl-DBI -y
yum install perl-DBD-MySQL -y
yum install perl-GD -y
cd /usr/bin/
curl -LOk http://xrl.us/cpanm
chmod +x cpanm
cpanm -f File::HomeDir
cpanm -f File::Which
cpanm CPAN::Meta::Requirements
cpanm -f CPAN
cpanm YAML
cpanm MD5
cpanm Digest::MD5
cpanm Digest::SHA1
cpanm readline --force


cpanm Bundle::CPAN
cpanm DBI
cpanm -f DBD::mysql
cpanm Net::Telnet
cpanm Time::HiRes
cpanm Net::Server
cpanm Switch
cpanm Mail::Sendmail
cpanm Unicode::Map
cpanm Jcode
cpanm Spreadsheet::WriteExcel
cpanm OLE::Storage_Lite
cpanm Proc::ProcessTable
cpanm IO::Scalar
cpanm Spreadsheet::ParseExcel
cpanm Curses
cpanm Getopt::Long
cpanm Net::Domain
cpanm Term::ReadKey
cpanm Term::ANSIColor
cpanm Spreadsheet::XLSX
cpanm Spreadsheet::Read
cpanm LWP::UserAgent
cpanm HTML::Entities
cpanm HTML::Strip
cpanm HTML::FormatText
cpanm HTML::TreeBuilder
cpanm Time::Local
cpanm MIME::Decoder
cpanm Mail::POP3Client
cpanm Mail::IMAPClient
cpanm Mail::Message
cpanm IO::Socket::SSL
cpanm MIME::Base64
cpanm MIME::QuotedPrint
cpanm Crypt::Eksblowfish::Bcrypt
cpanm Crypt::RC4
cpanm Text::CSV
cpanm Text::CSV_XS


########################################################################################################3

#Install Asterisk Perl
cd /usr/src
wget http://download.vicidial.com/required-apps/asterisk-perl-0.08.tar.gz
tar xzf asterisk-perl-0.08.tar.gz
cd asterisk-perl-0.08
perl Makefile.PL
make all
make install 

dnf --enablerepo=powertools install libsrtp-devel -y
yum install -y elfutils-libelf-devel libedit-devel


#Install Lame
cd /usr/src
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar -zxf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure
make
make install


#Install Jansson
cd /usr/src/
wget https://digip.org/jansson/releases/jansson-2.13.tar.gz
tar xvzf jansson*
cd jansson-2.13
./configure
make clean
make
make install 
ldconfig

#Install Dahdi
echo "Install Dahdi"
cd /usr/src/
wget https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-3.2.0+3.2.0.tar.gz
tar xzf dahdi*
cd /usr/src/dahdi-linux-complete-3.2.0+3.2.0

sudo sed -i 's|, 64);|);|g' /usr/src/dahdi-linux-complete-3.2.0+3.2.0/linux/drivers/dahdi/wctc4xxp/base.c
sudo sed -i 's|<linux/pci-aspm.h>|<linux/pci.h>|g' /usr/src/dahdi-linux-complete-3.2.0+3.2.0/linux/include/dahdi/kernel.h

yum -y install kernel-devel-$(uname -r)

make
make install
make install-config

yum -y install dahdi-tools-libs

cd tools
make clean
make
make install
make install-config

modprobe dahdi
modprobe dahdi_dummy

cp /etc/dahdi/system.conf.sample /etc/dahdi/system.conf
/usr/sbin/dahdi_cfg -vvvvvvvvvvvvv

cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/libpri/releases/libpri-1.6.1.tar.gz
tar -xvzf libpri-$ver.tar.gz
cd libpri-$ver
make
make install

yum install asterisk -y
yum install asterisk-* -y
wget -O asterisk-16.17.0-vici.tar.gz http://download.vicidial.com/beta-apps/asterisk-16.17.0-vici.tar.gz
tar -xvzf asterisk-16.17.0-vici.tar.gz
cd asterisk-16.17.0-vici

: ${JOBS:=$(( $(nproc) + $(nproc) / 2 ))}
./configure --libdir=/usr/lib64 --with-gsm=internal --enable-opus --enable-srtp --with-ssl --enable-asteriskssl --with-pjproject-bundled --with-jansson-bundled

#### asterisk menuselect preconfig
make menuselect/menuselect menuselect-tree menuselect.makeopts
#enable app_meetme
menuselect/menuselect --enable app_meetme menuselect.makeopts
#enable res_http_websocket
menuselect/menuselect --enable res_http_websocket menuselect.makeopts
#enable res_srtp
menuselect/menuselect --enable res_srtp menuselect.makeopts
make -j ${JOBS} all
make install
make samples
make config

systemctl enable asterisk && systemctl start asterisk

cp /usr/src/asterisk-16.30.0/contrib/init.d/rc.redhat.asterisk /etc/init.d/asterisk


\cp -r /usr/src/vici-cron /usr/src/vici-cron.original 
#wget -O /usr/src/vici-cron https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/vici-cron
crontab -l > vici-cron.original
crontab < vici-cron

cd /usr/src
\cp -r /etc/rc.d/rc.local /etc/rc.d/rc.local.original 
#wget -O /usr/src/rc.local https://github.com/ashloverscn/Vicidial-Scratch-Install-CentOS-7-2207-2-x86_64-Minimal-Server/raw/main/rc.local
\cp -r /usr/src/rc.local /etc/rc.d/rc.local

chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
systemctl start rc-local


cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-ulaw-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-wav-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-gsm-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-ulaw-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-wav-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-gsm-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-moh-opsound-gsm-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-moh-opsound-ulaw-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-moh-opsound-wav-current.tar.gz

cd /var/lib/asterisk/sounds
tar -zxf /usr/src/asterisk-core-sounds-en-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-core-sounds-en-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-core-sounds-en-wav-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-wav-current.tar.gz

mkdir /var/lib/asterisk/mohmp3
mkdir /var/lib/asterisk/quiet-mp3
ln -s /var/lib/asterisk/mohmp3 /var/lib/asterisk/default
cd /var/lib/asterisk/mohmp3
tar -zxf /usr/src/asterisk-moh-opsound-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-moh-opsound-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-moh-opsound-wav-current.tar.gz
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*
cd /var/lib/asterisk/moh
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*
cd /var/lib/asterisk/sounds
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*

cd /var/lib/asterisk/quiet-mp3
sox ../mohmp3/macroform-cold_day.wav macroform-cold_day.wav vol 0.25
sox ../mohmp3/macroform-cold_day.gsm macroform-cold_day.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-cold_day.ulaw -t ul macroform-cold_day.ulaw vol 0.25
sox ../mohmp3/macroform-robot_dity.wav macroform-robot_dity.wav vol 0.25
sox ../mohmp3/macroform-robot_dity.gsm macroform-robot_dity.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-robot_dity.ulaw -t ul macroform-robot_dity.ulaw vol 0.25
sox ../mohmp3/macroform-the_simplicity.wav macroform-the_simplicity.wav vol 0.25
sox ../mohmp3/macroform-the_simplicity.gsm macroform-the_simplicity.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-the_simplicity.ulaw -t ul macroform-the_simplicity.ulaw vol 0.25
sox ../mohmp3/reno_project-system.wav reno_project-system.wav vol 0.25
sox ../mohmp3/reno_project-system.gsm reno_project-system.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/reno_project-system.ulaw -t ul reno_project-system.ulaw vol 0.25
sox ../mohmp3/manolo_camp-morning_coffee.wav manolo_camp-morning_coffee.wav vol 0.25
sox ../mohmp3/manolo_camp-morning_coffee.gsm manolo_camp-morning_coffee.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/manolo_camp-morning_coffee.ulaw -t ul manolo_camp-morning_coffee.ulaw vol 0.25

