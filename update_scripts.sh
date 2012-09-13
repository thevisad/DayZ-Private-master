#!/bin/bash
cd deploy/Bliss/BattlEye/
echo "Changed directory to Bliss"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
echo "Updated scripts.txt"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
echo "Updated remoteexec.txt"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
echo "Updated createvehicle.txt"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariable.txt
echo "Updated publicvariable.txt"

cd ../../BlissLingor/BattlEye/
echo "Changed directory to BlissLingor"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
echo "Updated scripts.txt"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
echo "Updated remoteexec.txt"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
echo "Updated createvehicle.txt"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariable.txt
echo "Updated publicvariable.txt"
