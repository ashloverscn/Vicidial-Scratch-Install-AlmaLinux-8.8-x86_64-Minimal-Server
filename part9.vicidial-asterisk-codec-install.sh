#!/bin/bash

# codec-install.sh version 1.00
#
# Copyright (C) 2018  James Pearson <jamesp@vicidial.com>    LICENSE: AGPLv2
#


# Codecs installed from http://asterisk.hosting.lv/
# Supports 64-bit Asterisk v.1.8, 11, 12, 13, 14, 15, 16, 17, 18

# Get our variables
CPUNAME="$(cut -d':' -f2 <<<`cat /proc/cpuinfo | grep 'model name' | sed -n 1p`)"
CPUVEN="$(cut -d':' -f2 <<<`cat /proc/cpuinfo | grep 'vendor' | sed -n 1p`)"
CPUFAM="$(cut -d':' -f2 <<<`cat /proc/cpuinfo | grep 'family' | sed -n 1p`)"
CPUFLAG="$(cut -d':' -f2 <<<`cat /proc/cpuinfo | grep 'flag' | sed -n 1p`)"
G729='codec_g729-'
G723='codec_g723-'
CPUARCH='' # Autodetected below, should be blank
OSARCH='gcc4-glibc-x86_64-'
ASTVER='' # Autodetected below, should be blank
URL='http://asterisk.hosting.lv/bin/' # Must be in http://FQDN/dir/  format
FQDN="$(cut -d'/' -f3 <<<$URL)" # Taken from the URL variable set above this, do not modify
SRCDIR='/usr/src/astguiclient/conf/codecs/' # locally seeded copy of codecs in case we don't have internet
MODDIR='/usr/lib64/asterisk/modules/'
AST_BIN=/usr/sbin/asterisk

# Debug output
#echo CPU Vendor - $CPUVEN
#echo CPU Family - $CPUFAM
#echo CPU Flags - $CPUFLAG

# Make sure asterisk is even installed before continuing
if [ ! -x $AST_BIN ]; then
  echo "No $AST_BIN found! Is asterisk installed?";
  exit
fi
if [ ! -d $MODDIR ]; then
  echo "No asterisk module directory found at $MODDIR"
  exit
fi

echo 
echo "---  Asterisk G729/G723 codec installer for AMD and Intel 64-bit CPUs"
echo "---  Written by James Pearson at ViciDial Group <jamesp@vicidial.com>"
echo "---  Supports Asterisk v.1.8, 11, 12, 13, 14, 15, 16, 18, and 18 only"
echo "---  Please make sure you have internet connectivity to download codecs"
echo

### Make sure we have a supported Asterisk version or exit
RAWASTVER=`$AST_BIN -V`
RAWASTARY=($RAWASTVER)
ASTVERSION=${RAWASTARY[1]}
if [[ $ASTVERSION =~ ^18 ]]; then
  ASTVER="ast180-"
  echo "  Found Asterisk 18 - v.$ASTVERSION"
fi
if [[ $ASTVERSION =~ ^17 ]]; then
  ASTVER="ast170-"
  echo "  Found Asterisk 17 - v.$ASTVERSION"
fi
if [[ $ASTVERSION =~ ^16 ]]; then
  ASTVER="ast160-"
  echo "  Found Asterisk 16 - v.$ASTVERSION"
fi
if [[ $ASTVERSION =~ ^15 ]]; then
  ASTVER="ast150-"
  echo "  Found Asterisk 15 - v.$ASTVERSION"
fi
if [[ $ASTVERSION =~ ^14 ]]; then
  ASTVER="ast140-"
  echo "  Found Asterisk 14 - v.$ASTVERSION"
fi
if [[ $ASTVERSION =~ ^13 ]]; then
  ASTVER="ast130-"
  echo "  Found Asterisk 13 - v.$ASTVERSION"
fi
if [[ $ASTVERSION =~ ^12 ]]; then
  ASTVER="ast120-"
  echo "  Found Asterisk 12 - v.$ASTVERSION"
fi
if [[ $ASTVERSION =~ ^11 ]]; then
  ASTVER="ast110-"
  echo "  Found Asterisk 11 - v.$ASTVERSION"
fi
if [[ $ASTVERSION =~ ^1.8 ]]; then
  ASTVER="ast18-"
  echo "  Found Asterisk 1.8 - v.$ASTVERSION"
fi
if [ ${#ASTVER} -lt 5 ]; then
  echo "  No supported asterisk version found! Asterisk reported as $RAWASTVER"
  exit
fi

### Detect CPU brand/family/model/etc, and build the filename for the codec we need
if [[ "$CPUVEN" == *"AMD"* ]]; then # Handle AMD CPUs
  echo -n "  Found AMD CPU, "
  if [ $CPUFAM -ge 10 ]; then
    echo "Barcelona core or better"
    CPUARCH='barcelona.so'
  elif [ $CPUFAM -ge 8 ]; then
    echo -n "Opteron Core, "
    if [[ "$CPUFLAG" == *"sse3"* ]]; then
      echo "with SSE3 instructions"
      CPUARCH='opteron-sse3.so'
    else
      echo "without SSE3 instructions"
      CPUARCH='opteron.so'
    fi
  else
    echo "but no supported codec found for architecture"
    exit
  fi
  
elif [[ "$CPUVEN" == *"Intel"* ]]; then # Handle Intel CPUs
  echo -n "  Found Intel CPU, "
  if [ $CPUFAM -eq 6 ]; then
    echo -n "Core2 arch or better, "
    if [[ "$CPUFLAG" == *"sse4"* ]]; then
      echo "with SSE4 instructions"
      CPUARCH='core2-sse4.so'
    else
      echo "without SSE4 instructions"
      CPUARCH='core2.so'
    fi
  elif [[ "$CPUNAME" == *"Pentium(R) 4"* ]]; then
    echo "NetBurst P4 arch"
	CPUARCH="pentium4.so"
  fi
else # Just in case of someone blindly copy-pasta, exit if we aren't a supported CPU
  echo "  Could not find compatible Intel or AMD CPU!"
  echo "    CPU Found: $CPUNAME"
  exit
fi


# Finally install from internet or local copies
ping -c3 $FQDN >/dev/null 2>&1 
if [ $? -ne 0 ]; then
  echo "  Installing from local copies, could not connect to $FQDN"
  if [ -f $SRCDIR$G729$ASTVER$OSARCH$CPUARCH ]; then
    echo "    Installing G729 - $G729"
    cp $SRCDIR$G729$ASTVER$OSARCH$CPUARCH $MODDIR/codec_g729.so
  else
    echo "Could not find $SRCDIR$G729$ASTVER$OSARCH$CPUARCH to install!"
  fi
  if [ -f $SRCDIR$G723$ASTVER$OSARCH$CPUARCH ]; then
    echo "    Installing G723 - $G723"
    cp $SRCDIR$G723$ASTVER$OSARCH$CPUARCH $MODDIR/codec_g723.so
  else
    echo "Could not find $SRCDIR$G723$ASTVER$OSARCH$CPUARCH to install!"
  fi
else
  echo "  Installing from $FQDN"
  cd /tmp
  if [ -f "codec_g72"* ]; then rm codec_g72*; fi;
  
  # Download G729 and give output
  echo -n "    Downloading G729 - $G729$ASTVER$OSARCH$CPUARCH... "
  wget -q $URL$G729$ASTVER$OSARCH$CPUARCH
  if [ $? -ne 0 ]; then
    echo "ERROR"
    echo "      Could not download from $URL"
  else
    mv -f $G729$ASTVER$OSARCH$CPUARCH $MODDIR/codec_g729.so
    echo "done"
  fi
  
  # Download G723 and give output
  echo -n "    Downloading G723 - $G723$ASTVER$OSARCH$CPUARCH... "
  wget -q $URL$G723$ASTVER$OSARCH$CPUARCH
  if [ $? -ne 0 ]; then
    echo "ERROR"
    echo "      Could not download from $URL"
  else
    mv -f $G723$ASTVER$OSARCH$CPUARCH $MODDIR/codec_g723.so
    echo "done"
  fi
fi

# Load codec if asterisk running or just give output
ASTERISK_PS=`/usr/bin/ps ax | /usr/bin/grep asterisk | /usr/bin/grep -v grep | /usr/bin/grep -v SCREEN`
if [[ $ASTERISK_PS ]]; then
  ASTERISK_PID=($ASTERISK_PS)
  echo
  echo "  Loading codec modules into asterisk PID $ASTERISK_PID..."
  if [ -f $MODDIR/codec_g729.so ]; then
    echo -n "    Loading module codec_g729.so... "
    $AST_BIN -rx "module load codec_g729.so" >/dev/null 2>&1 
    echo "done"
  fi
  if [ -f $MODDIR/codec_g723.so ]; then
    echo -n "    Loading module codec_g723.so... "
    $AST_BIN -rx "module load codec_g723.so" >/dev/null 2>&1 
    echo "done"
  fi
else
  echo "  Asterisk not running, skipping module load"
fi

echo "  Finished"
echo


