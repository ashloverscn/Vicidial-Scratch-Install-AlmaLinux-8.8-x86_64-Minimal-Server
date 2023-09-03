#!/bin/sh
ver=2.13
echo -e "\e[0;32m Install Jansson v$ver \e[0m"
sleep 2
cd /usr/src/
wget http://www.digip.org/jansson/releases/jansson-$ver.tar.gz
tar -zxf jansson-$ver.tar.gz
#tar xvzf jasson-$ver.tar.gz
cd jansson-$ver
./configure
make clean
make
make install
ldconfig
