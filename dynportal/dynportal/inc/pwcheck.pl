#!/usr/bin/perl

# Dirty dirty perl wrapper since the default BCrypt cost used in ViciDial is 2 and PHP only goes as low as 4

use Crypt::Eksblowfish::Bcrypt qw(en_base64);

# Load our salt and base64 it if it's not 22 characters
if (length($ARGV[1])==16) { $salt=en_base64($ARGV[1]); } else { $salt=$ARGV[1]; }
$password = $ARGV[0];
$cost = sprintf("%02d", $ARGV[2]);

# Set the cost to $cost and append a NUL
$settings = '$2a$'.$cost.'$'.$salt;
 
# Encrypt it
$pass_hash = Crypt::Eksblowfish::Bcrypt::bcrypt($password, $settings);
$pass_hash = substr($pass_hash,29,31);

# Return the hash string
print $pass_hash;

