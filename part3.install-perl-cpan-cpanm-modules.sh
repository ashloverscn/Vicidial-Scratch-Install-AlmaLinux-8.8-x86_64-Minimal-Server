#!/bin/sh

echo -e "\e[0;32m Install and Configure Perl-CPAN\Perl-CPAN-Modules \e[0m"
sleep 2
yum install -y perl-CPAN perl-YAML perl-CPAN-DistnameInfo perl-libwww-perl perl-DBI perl-DBD-MySQL perl-GD perl-Env perl-Term-ReadLine-Gnu perl-SelfLoader perl-open.noarch 
echo -e "\e[0;32m All cpan-modules installed and verified successfuly \e[0m"
sleep 2



