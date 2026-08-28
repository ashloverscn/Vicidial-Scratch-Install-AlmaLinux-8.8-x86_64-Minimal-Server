<?php

// Default database connection if we aren't given a config file
$DB_server='localhost';
$DB_database='asterisk';
$DB_user='cron';
$DB_pass='1234';
$DB_port=3306;

// Read configuration file
debugoutput("Conf file: $AST_conffile",2);
if ( file_exists($AST_conffile) ) {
	$DBCfile = file($AST_conffile);
	foreach ($DBCfile as $DBCline) {
		$DBCline = preg_replace("/ |>|\n|\r|\t|\#.*|;.*/","",$DBCline);
		if (preg_match("/VARDB_server/", $DBCline))
			{$DB_server = $DBCline;	 $DB_server = preg_replace("/.*=/","",$DB_server); }
		if (preg_match("/VARDB_database/", $DBCline))
			{$DB_database = $DBCline;	 $DB_database = preg_replace("/.*=/","",$DB_database); }
		if (preg_match("/VARDB_user/", $DBCline))
			{$DB_user = $DBCline;	 $DB_user = preg_replace("/.*=/","",$DB_user); }
		if (preg_match("/VARDB_pass/", $DBCline))
			{$DB_pass = $DBCline;	 $DB_pass = preg_replace("/.*=/","",$DB_pass); }
		if (preg_match("/VARDB_port/", $DBCline))
			{$DB_port = $DBCline;	 $DB_port = preg_replace("/.*=/","",$DB_port); }
	}
}

// Debug output function, so i'm not repeating things ad nauseum
function debugoutput ($DEBUGout,$DEBUGlvl=1,$DEBUGdie=0) {
	global $PORTAL_mode;
	global $PORTAL_logfile;
	if ( $DEBUGlvl <= $PORTAL_mode ) {
		$logfile = fopen("$PORTAL_logfile","a");
		fwrite($logfile,$DEBUGout . "\n");
		fclose($logfile);
	}
	if ($DEBUGdie==1) { die(); }
}

debugoutput("DB Host: $DB_server",2);
debugoutput("DB User: $DB_user",2);
debugoutput("DB Pass: $DB_pass",2);
debugoutput("DB Name: $DB_database",2);
debugoutput("DB Port: $DB_port",2);

// Setup database connections
$dbVICI = mysqli_connect($DB_server, $DB_user, $DB_pass, $DB_database, $DB_port);
if (!$dbVICI) { die("<b>MySQL dbVICI connect ERROR: " . mysqli_connect_error() . "<br></b>\n"); }

?>
