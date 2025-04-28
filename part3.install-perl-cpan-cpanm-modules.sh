#!/bin/sh

echo -e "\e[0;32m Install and Configure Perl-CPAN\Perl-CPAN-Modules \e[0m"
sleep 2
cd /usr/src
which cpm
yum install -y perl-CPAN perl-YAML perl-CPAN-DistnameInfo perl-libwww-perl perl-DBI perl-DBD-MySQL perl-GD perl-Env perl-Term-ReadLine-Gnu perl-SelfLoader perl-open.noarch 
cpm --clean
##CPM complete uninstall remove
rm -f $(which cpm)
rm -rf ~/.perl-cpm
rm -rf /usr/local/lib/*/perl/*
rm -rf /usr/local/share/perl/*
rm -rf /usr/local/bin/cpm
rm -rf /bin/cpm
rm -rf ~/.cpanm
rm -rf ~/.cpan

##CPM install
curl -fsSL https://raw.githubusercontent.com/skaji/cpm/master/cpm > /usr/local/bin/cpm
curl -fsSL https://raw.githubusercontent.com/skaji/cpm/master/cpm > /bin/cpm
chmod +x /usr/local/bin/cpm
chmod +x /bin/cpm
##seup cpm mirror (may be installed without mirrorS too)
#export PERL_CPANM_OPT="--mirror http://www.cpan.org/ --mirror-only"
##install cpm modules globally for all uSerS
#cpm install -g
##install cpm basic essential
#cpm install -g JSON::PP
#cpm install -g JSON::XS
#cpm install -g App::cpanminus
#cpm install -g JSON::PP JSON::XS App::cpanminus
##oneliner for CPM install using mirror
curl -fsSL https://raw.githubusercontent.com/skaji/cpm/main/cpm | perl - install -g App::cpm
/usr/local/bin/cpm install -g --mirror http://www.cpan.org 
echo -e "\e[0;32m All cpan-modules installed and verified successfuly \e[0m"
sleep 2



