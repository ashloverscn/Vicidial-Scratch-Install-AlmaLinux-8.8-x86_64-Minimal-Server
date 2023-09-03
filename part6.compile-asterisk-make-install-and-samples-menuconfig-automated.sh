#!/bin/sh
#ver=13.29.2
#ver=16.17.0
#oem=0
#oem=1
#subdr=required-apps
#subdr=beta-apps
subdr=beta-apps
ver=16.30.0
oem=0

echo -e "\e[0;32m Install Asterisk v$ver$oem \e[0m"
sleep 2
cd /usr/src
#rm -rf asterisk*
#yum remove asterisk -y
#yum remove asterisk-* -y
yum install asterisk -y
yum install asterisk-* -y
if [ $oem -eq 1 ]
then
wget -O asterisk-$ver-vici.tar.gz http://download.vicidial.com/$subdr/asterisk-$ver-vici.tar.gz
tar -xvzf asterisk-$ver-vici.tar.gz
cd asterisk-$ver-vici

else
wget -O asterisk-$ver.tar.gz https://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-$ver.tar.gz
tar -xvzf asterisk-$ver.tar.gz
cd asterisk-$ver
wget https://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-$ver-patch.tar.gz
tar -xvzf asterisk-$ver-patch.tar.gz
#patch if needed
#patch -p0 < asterisk-$ver-patch

fi

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

\cp -r /usr/src/asterisk-$ver/contrib/init.d/rc.redhat.asterisk /etc/init.d/asterisk


