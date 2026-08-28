<?php

# Default settings
$PORTAL_mode=0; // 0 = Production mode, 1 = Normal Debug, 2 = Extended Debug (this is a security risk, so use sparingly!)
$PORTAL_secure=0; // 1 = Enable forced HTTPS, 0 = Disable forced HTTPS; If you aren't running on standard SSL ports this probably won't work!!!
$PORTAL_logfile='debug.txt'; // Log file to write debug output to, does nothing otherwise
$PORTAL_userlevel=1; // Minimum required ViciDial user level to enable dynamic portal authentication
$PORTAL_topbar=1; // Whether to display the topbar with image or not
$PORTAL_redirecturl='https://192.168.29.203/index.html'; // X = Disabled, otherwise set to a url like https://server.ip/agc/vicidial.php
$PORTAL_redirectadmin='https://server-iporfqdn/vicidial/admin.php'; // Only matters if the above is not X and the valued of the $PORTAL_adminfield in vicidial_users equals 'admin'
$PORTAL_redirectsecs=0; // How long to count down before redirecting in seconds
$PORTAL_redirectlogin=1; // 1 = Provide User/Phone Login, 0 = Do not provide User/Phone login
$PORTAL_adminfield='phone_login'; // The field from vicidial_users to look for the word 'admin' in to determine redirect URL
$PORTAL_incurdelay=1; // Seconds to delay ALL submit requests, 0=Disabled  (This is a brute-force counter measure)
$PORTAL_useridvar='Jzr87Cp8XqJY'; // The HTML form User ID variable name to use, helps prevent script kiddies, use Alpha Numerics only, no whitespace
$PORTAL_passwdvar='WNK1WOrAvT1I'; // The HTML form Password variable name to use, helps prevent script kiddos, use Alpha Numerics only, no whitespace
$PORTAL_casesensitive=0; // 0 = Not Case Sensitive, 1 = Case Sensitive Password, 2 = Case Sensitive Password and User
$PORTAL_countunsuccessful=0; // Increase the failed_login_count in vicidial_users for each unsuccessful portal auth attempt; 0 = Disabled, 1 = Enabled
$PORTAL_unsuccessfullimit=5; // Max number of unsuccessful attempts allowed before ignoring subsequent requests, taken from vicidial_users.failed_login_count
$PORTAL_submitlocal=0; // 1 = enabled; Submit local IPSet changes directly in addition to inserting into the database; Only works for the local server and /usr/sbin/ipset must have setuid which is a HYUUUGE security risk, so it doesn't work by default

# Default ViciDial conf file location
$AST_conffile="/etc/astguiclient.conf"; // If this isn't present the defaults are used from dbconnect.inc.php

?>
