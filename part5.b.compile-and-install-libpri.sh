#!/bin/sh
ver=1.6.1

echo -e "\e[0;32m Install LibPri v$ver\e[0m"
sleep 2
cd /usr/src
#http://download.vicidial.com/required-apps/libpri-1.4.10.1.tar.gz
#http://downloads.asterisk.org/pub/telephony/libpri/releases/libpri-1.6.0.tar.gz
wget http://downloads.asterisk.org/pub/telephony/libpri/releases/libpri-$ver.tar.gz
tar -xvzf libpri-$ver.tar.gz
cd libpri-$ver
make
make install

