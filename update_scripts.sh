#!/bin/bash
cd deploy/Bliss/BattlEye/
echo "Changed directory to Bliss"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariable.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariableval.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariablevar.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/setpos.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/mpeventhandler.txt

cd ../../BlissLingor/BattlEye/
echo "Changed directory to BlissLingor"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariable.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariableval.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariablevar.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/setpos.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/mpeventhandler.txt

echo "Updated BE files!"
