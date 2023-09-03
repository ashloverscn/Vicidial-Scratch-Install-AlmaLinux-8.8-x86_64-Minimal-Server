#!/bin/sh
ver=3.100
echo -e "\e[0;32m Install Lame v$ver \e[0m"
sleep 2
cd /usr/src
wget http://downloads.sourceforge.net/project/lame/lame/$ver/lame-$ver.tar.gz
tar -zxf lame-$ver.tar.gz
cd lame-$ver
./configure
make
make install

