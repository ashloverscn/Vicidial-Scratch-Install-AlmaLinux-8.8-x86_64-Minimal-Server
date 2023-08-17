#!/bin/sh

#https://568588.bugs.gentoo.org/attachment.cgi?id=419546
#https://bugs.gentoo.org/attachment.cgi?id=419546&action=diff
#https://packages.gentoo.org/packages/net-misc/sipsak/qa-report
#https://github.com/nils-ohlmeier/sipsak
#https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/sipsak.rb

echo -e "\e[0;32m Install SIPSack \e[0m"
sleep 2
cd /usr/src
wget http://download.vicidial.com/required-apps/sipsak-0.9.6-1.tar.gz
tar -zxf sipsak-0.9.6-1.tar.gz
cd sipsak-0.9.6
./configure
make
make install
/usr/local/bin/sipsak --version
sipsak --version

