#!/bin/sh

#https://github.com/asterisk-perl/asterisk-perl
#https://metacpan.org/dist/asterisk-perl

echo -e "\e[0;32m Install Asterisk Perl \e[0m"
sleep 2
cd /usr/src
wget http://download.vicidial.com/required-apps/asterisk-perl-0.08.tar.gz
tar xzf asterisk-perl-0.08.tar.gz
cd asterisk-perl-0.08
perl Makefile.PL
make all
make install

