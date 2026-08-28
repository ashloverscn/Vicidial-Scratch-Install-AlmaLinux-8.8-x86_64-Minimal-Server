# vicidial-dynamicportal
https://www.striker24x7.com/2022/11/how-to-scratch-install-vicidial-dynamic-portal-in-centos.html
https://www.striker24x7.com/2022/03/vicibox10-dynamic-portal-configuration-dynamic-ip-list.html
https://www.striker24x7.com/2021/05/howto-configure-vicibox-dynamicportal.html

cp VB-firewall /usr/bin/

chmod +x /usr/bin/VB-firewall

cp -r zones /etc/firewalld/

cp vicidial-sss.conf /etc/httpd/conf.d/

cd /servcies

cp *.xml /usr/lib/firewalld/services/

cp -r dynamicportal /var/www/html/
