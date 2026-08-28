<?php
# valid8.php - ViciBox dynamic firewall validation portal
#
# Copyright (C) 2018  James Pearson <jamesp@vicidial.com>    LICENSE: AGPLv2
# 
# See the CHANGES file in the ./inc directory for the change log
#

// Required includes
require_once 'inc/defaults.inc.php'; // Edit this for astguiclient.conf location
require_once 'inc/dbconnect.inc.php';
require_once 'inc/functions.inc.php';

// See if we are redirected from elsewhere and are secure
$loginstate=0; // 0 = no attempt, 1 = failed, 2 = success
if (chkgetpost("login")) { $loginstate=getpostvar("login"); }

// If we are submitted, then do stuff, otherwise output HTML
if (chkgetpost('submit')) {
	$remoteip=$_SERVER['REMOTE_ADDR'];
	debugoutput("   IP $remoteip validation check submit",2);
	// Get our login and password and set our vars
	$login = getpostvar("$PORTAL_useridvar");
	$pass = getpostvar("$PORTAL_passwdvar");
	$usergroup = '';
	debugoutput("Login: $login",2);
	debugoutput("Pass: $pass",2);
	$today = date("Y-m-d H:i:s");
	
	// Force a delay if configured to reduce the attractiveness of brute-forcing a login
	if ($PORTAL_incurdelay>0) {
		sleep($PORTAL_incurdelay);
	}
	
	if (validate_pw($login,$pass)) {
		#logaction($login,'LOGIN',$_SERVER['REMOTE_ADDR']);
		$loginstate=2;
		logvalidip($login, $remoteip, $usergroup);
		debugoutput("Login Successful $today - User $login, IP $remoteip");
		
		# Insert the IP address into the local IPSet when authenticated
		if ($PORTAL_submitlocal == 1) {
			debugoutput("  Adding $remoteip to dynamiclist IPSET and Authedzone", 2);
			
			$safe_ip = escapeshellarg($remoteip);

			// 1. Add via firewalld command so it registers cleanly with the runtime rules
			$cmd_fw = "/usr/bin/firewall-cmd --ipset=dynamiclist --add-entry={$safe_ip} 2>&1";
			shell_exec($cmd_fw);

			// 2. Direct kernel fallback using ipset to guarantee instant activation
			$cmd_ipset = "/usr/sbin/ipset add dynamiclist {$safe_ip} 2>&1";
			shell_exec($cmd_ipset);
		}
		
		} else {
			#logaction($login,'FAILEDLOGIN',$_SERVER['REMOTE_ADDR']);
			$loginstate=1;
			debugoutput("Login Unsuccessful $today - User $login, IP $remoteip");
	}
} 

?>

<!DOCTYPE html>
<!-- valid8.php - ViciNOC login interface
#
# Copyright (C) 2018  James Pearson <jamesp@vicidial.com>    LICENSE: AGPLv2
#
-->
<html>
<head>
<title>User Validation</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<style>
html,body,h1,h2,h3,h4,h5 {font-family: "Arial", sans-serif}
</style>

<?php
// If we have a redirect URL, configure it dynamically before header outputs
if ( $loginstate==2 && $PORTAL_redirecturl!='X' ) {
    $clean_host = preg_replace('/:\d+/', '', $_SERVER['HTTP_HOST']);
    $PORTAL_redirecturl = "https://" . $clean_host . "/index.html";
    $PORTAL_redirectlogin = 0;
    
    // Fallback default to 2 seconds if config value is 0 or missing
    $redirect_secs = (intval($PORTAL_redirectsecs) > 0) ? intval($PORTAL_redirectsecs) : 2;
?>
<meta http-equiv="refresh" content="<?php echo $redirect_secs; ?>;url=<?php echo $PORTAL_redirecturl; ?>">
<?php } ?>
</head>
<body>

<?php
// If the topbar is to be displayed output that code here
if ($PORTAL_topbar >= 1) {
echo
'<!-- Top Bar container -->
<div class="w3-container w3-top w3-large w3-padding" style="z-index:4">
  <img src="images/vicibox.png" class="w3-middle" style="width:270px">
</div>';
}
?>
<!-- Main login container -->
<div class="w3-main w3-round-large w3-border w3-pale-green w3-leftbar" style="margin-left:40px;margin-top:70px;padding-left:20px;padding-bottom:22px;width:230px">
  <header class="w3-container">
    <h4><b>Agent Validation</b></h4>
  </header>
  <form action="valid8.php" method="post">
    <b>&nbsp;&nbsp;User ID</b><br>
    <input type="text" id="<?php echo $PORTAL_useridvar; ?>" name="<?php echo $PORTAL_useridvar; ?>" value="" class="w3-round">
    <br>
    <b>&nbsp;&nbsp;Password</b><br>
    <input type="hidden" id="password" name="password"/>
    <input type="password" id="<?php echo $PORTAL_passwdvar; ?>" name="<?php echo $PORTAL_passwdvar; ?>" value="" class="w3-round">
    <br><br>
    <input type="submit" class="w3-btn w3-blue-grey w3-hover-blue w3-round w3-medium w3-border w3-text-shadow w3-ripple" value="Submit" style="margin-left:47px" name="submit">
  </form> 



<?php
// Set some useful dynamic feedback based upon what is going
if ($loginstate==1) {
	echo'<h5><center><font color="red"><b>Login Incorrect!</b></font></center></h5>';
	
	} elseif ($loginstate==2) {
	echo'<h5><center><font color="green"><b>Login Validated for<br>IP ' . $remoteip . '</b></font></center></h5>';
	
} elseif (!checksecure()) {
	echo'<!-- Bottom container -->
<div class="w3-container w3-large w3-padding w3-text-red" style="z-index:4;margin-left:41px">
  <h6><b>Connection not using SSL!</b></h6>
</div>
';
}
?>
</div>

<?php

// If we have a redirect URL, then put our countdown here
if ( $loginstate==2 && $PORTAL_redirecturl!='X' ) {
	debugoutput("   Portal Redirect to $PORTAL_redirecturl in $redirect_secs",2);
?>

<script type="text/javascript">
(function() {
    var timeInSecs = <?php echo $redirect_secs; ?>;
    var redirectUrl = "<?php echo $PORTAL_redirecturl; ?>";

    var ticker = setInterval(function() {
        if (timeInSecs > 1) {
            timeInSecs--;
            var el = document.getElementById("countdown");
            if (el) { el.innerHTML = timeInSecs; }
        } else {
            clearInterval(ticker);
            window.location.href = redirectUrl;
        }
    }, 1000);
})();
</script>

<div class="w3-main " style="margin-left:40px;margin-top:70px;padding-left:20px;padding-bottom:22px;width:230px"><h4>Redirecting to <a href="<?php echo $PORTAL_redirecturl; ?>">Welcome Page</a> in <span id="countdown" style="font-weight: bold;color:red;"><?php echo $redirect_secs; ?></span> seconds.<br>Please Bookmark the login page for easier access in the future.</h4>
</div>
<?php
}
?>
</body>
</html>
