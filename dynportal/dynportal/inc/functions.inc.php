<?php
// Contains general all-purpose functions not spefically for any one thing

// ChangeLog
// 200401 - Patched thanks to bugtracker submission by 'fido'

# Check for HTTPS if in secure mode and redirect if we aren't
function checksecure() {
	debugoutput("FUNCTION checksecure",2);
	global $PORTAL_secure;
	if ($PORTAL_secure==1) {
		if(!isset($_SERVER["HTTPS"]) || $_SERVER["HTTPS"] != "on") {
			header("Location: https://" . $_SERVER["HTTP_HOST"] . $_SERVER["REQUEST_URI"]);
			debugoutput("   Security required, redirecting to : https://" . $_SERVER["HTTP_HOST"] . $_SERVER["REQUEST_URI"],2);
			debugoutput("FUNCTION checksecure END",2);
			exit;
		} else {
			debugoutput("   Security required but not available, stopping output",2);
			die("SSL is required but not available!<br>\n");
		}
	} else {
		debugoutput("   Security not required, skipping check",2);
		debugoutput("FUNCTION checksecure END",2);
		return true;
	}
}

// returns the filtered variable from a post or get
function getpostvar($varname, $varfilter=FILTER_SANITIZE_STRING) {
	debugoutput("FUNCTION getpostvar - variable $varname",2);
	$result="";
	if (isset($_GET["$varname"])) { $result=filter_var($_GET["$varname"],$varfilter); }
	if (isset($_POST["$varname"])) { $result=filter_var($_POST["$varname"],$varfilter); }
	if ($result!="") { debugoutput("   Found $varname - $result",2); }
	debugoutput("FUNCTION getpostvar END",2);
	return $result;
}

// Simply returns true or false if the variable exists
function chkgetpost($varname) {
	debugoutput("FUNCTION chkgetpost - var $varname",2);
	$result=false;
	if (isset($_GET["$varname"])) { $result=true; debugoutput("   GET variable found",2); }
	if (isset($_POST["$varname"])) { $result=true; debugoutput("   POST variable found",2); }
	if ($result) { debugoutput("   Found variable",2); }
	debugoutput("FUNCTION chkgetpost END",2);
	return $result;
}

// Log validated IP to vicidial_user_log for dynamic firewall rules
function logvalidip($user, $ipaddress, $usergroup) {
	debugoutput("FUNCTION logvalidip - User: $user, Group: $usergroup, IP: $ipaddress",2);
	global $dbVICI;
	$logstmt = $dbVICI->prepare("insert into vicidial_user_log (user, event, event_date, user_group, campaign_id, computer_ip, data, event_epoch) values ( ?, 'VICIBOX', NOW(), ?, 'VICIBOX', ?, 'IP Validation Portal', UNIX_TIMESTAMP(NOW()));");
	$logstmt->bind_param('sss', $user, $usergroup, $ipaddress);
	$logstmt->execute();
	$logstmt->close();
	return true;
}

function getphonelogin($user) {
	global $PORTAL_casesensitive;
	global $PORTAL_adminfield;
	global $dbVICI;
	$phonelogin='';
	$phonepass='';
	$sql_ending='limit 1;'; # Default non-case sensitive sql ending
	if ($PORTAL_casesensitive>=2) { $sql_ending='limit 1 COLLATE utf8_bin';}
	$phonestmt = $dbVICI->prepare("select phone_login, phone_pass, $PORTAL_adminfield from vicidial_users where user=? $sql_ending;");
	$phonestmt->bind_param('s', $user);
	$phonestmt->execute();
	$phonestmt->bind_result($phonelogin, $phonepass, $adminfield);
	$phonestmt->fetch();
	$phonestmt->close();
	return array($phonelogin, $phonepass, $adminfield);
}

function validate_pw($user,$pass) {
	debugoutput("FUNCTION validate_pw - User: $user, Pass: $pass",2);
	global $PORTAL_casesensitive;
	global $PORTAL_unsuccessfullimit;
	global $PORTAL_countunsuccessful;
	global $dbVICI;
	global $PORTAL_userlevel;
	global $remoteip;
	global $usergroup;
	$result=false;
	debugoutput("   Minimum User level $PORTAL_userlevel",2);
	
	// See if we are using encrypted passwords
	$encryptcheck = $dbVICI->prepare("select pass_hash_enabled, pass_key, pass_cost from system_settings limit 1;");
	$encryptcheck->execute();
	$encryptcheck->bind_result($pwencrypt, $passkey, $passcost);
	$encryptcheck->fetch();
	$encryptcheck->close();
	debugoutput("   ViciDial password encryption settings $pwencrypt test",2);
	if ($pwencrypt>0) { debugoutput("   Pass Key: $passkey, Pass Cost: $passcost",2); }
	$user_clause='user=?'; # Default non-case sensitive user where clause
	$pass_clause='pass=?'; # Default non-case sensitive pass where clause
	if ($PORTAL_casesensitive>=1) { $pass_clause='pass=? COLLATE utf8_bin';}
	if ($PORTAL_casesensitive>=2) { $user_clause='user=? COLLATE utf8_bin';}
	if ($PORTAL_unsuccessfullimit<1) { $PORTAL_unsuccessfullimit=999; } # If someone puts in 0 give the appearance of disabling it
	
	// Check our password against the database
	if ($pwencrypt>0) {
		// Password check with encrypted passwords
		$pwstmt = $dbVICI->prepare("select user_id, pass_hash, user_group from vicidial_users where " . $user_clause . " and user_level>=? and active='Y' and failed_login_count < ? limit 1;");
		$pwstmt->bind_param('sss', $user, $PORTAL_userlevel, $PORTAL_unsuccessfullimit);
		$pwstmt->execute();
		$pwstmt->bind_result($userid, $passhash, $usergroup);
		$pwstmt->fetch();
		$pwstmt->close();
		debugoutput("   Pass hash : $passhash",2);
		$checkpasshash=exec("/usr/bin/perl ./inc/pwcheck.pl $pass $passkey $passcost");
		debugoutput("   Check hash : $checkpasshash",2);
	} else {
		// Password check for plaintext passwords
		$pwstmt = $dbVICI->prepare("select user_id, user_group from vicidial_users where " . $user_clause . " and " . $pass_clause . " and user_level>=? and active='Y' and failed_login_count < ? limit 1;");
		$pwstmt->bind_param('ssss', $user, $pass, $PORTAL_userlevel, $PORTAL_unsuccessfullimit);
		$pwstmt->execute();
		$pwstmt->bind_result($userid, $usergroup);
		$pwstmt->fetch();
		$pwstmt->close();
		debugoutput("   Plaintext User ID : $userid",2);
	}
	
	if ( $pwencrypt>0 && $checkpasshash == $passhash && $userid>=1 && $passhash!="" ) {
		// First compare passhash with password if encryption enabled
		debugoutput("   IP $remoteip - User $user validated encrypted IP $remoteip",2);
		$result=true;
		
	} elseif ( $pwencrypt==0 && $userid>=1) {
		// Second, compare if we got valid user_id returned
		debugoutput("   IP $remoteip - User $user validated IP $remoteip",2);
		$result=true;
		
	} else {
		// When all else fails, fail the login
		if ($PORTAL_countunsuccessful>0) {
			debugoutput("   IP $remoteip - User $user invalid auth attempt, incrementing failed_login_count",2);
			$updstmt = $dbVICI->prepare("UPDATE vicidial_users set failed_login_count=(failed_login_count+1), last_ip='?' where user='$user_clause';");
			$updstmt->bind_param('ss', $remoteip, $user);
			$updstmt->execute();
			$updstmt->close();
		} else {
		debugoutput("   IP $remoteip - User $user invalid auth attempt",2);
		}
	}
	debugoutput("FUNCTION validate_pw END",2);
	return $result;
}

?>
