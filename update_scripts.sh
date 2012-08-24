#!/bin/bash
cd deploy/Bliss/BattlEye/
wget --quiet -N http://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
echo "Updated scripts.txt"
wget --quiet -N http://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
echo "Updated remoteexec.txt"
wget --quiet -N http://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
echo "Updated createvehicle.txt"
