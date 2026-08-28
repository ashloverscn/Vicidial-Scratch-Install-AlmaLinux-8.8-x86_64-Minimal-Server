<?php
# logout.php - VICIdial Portal Session Cleaner & Strict IP De-Authentication
session_start();
$_SESSION = array();

if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

// Fetch and validate the client's current IP address
$remoteip = $_SERVER['REMOTE_ADDR'] ?? '';

if (!empty($remoteip) && filter_var($remoteip, FILTER_VALIDATE_IP)) {
    $safe_ip = escapeshellarg($remoteip);

    // 1. Remove from firewalld managed ipset
    $cmd_fw = "/usr/bin/firewall-cmd --ipset=dynamiclist --remove-entry={$safe_ip} 2>&1";
    shell_exec($cmd_fw);

    // 2. Direct kernel fallback to guarantee instant eviction from the set
    $cmd_ipset = "/usr/sbin/ipset del dynamiclist {$safe_ip} 2>&1";
    shell_exec($cmd_ipset);

    // 3. Clear active kernel connection tracking states (conntrack) 
    // This forces an immediate TCP disconnect so cached pages stop loading
    $cmd_conntrack = "/usr/sbin/conntrack -D -s {$safe_ip} 2>&1";
    shell_exec($cmd_conntrack);
}

session_destroy();

// Grab the current host and redirect cleanly back to port 446 login portal
$host = $_SERVER['HTTP_HOST'] ?? 'localhost';
$clean_host = preg_replace('/:\d+/', '', $host);

header("Location: https://{$clean_host}:446/valid8.php");
exit();
?>
