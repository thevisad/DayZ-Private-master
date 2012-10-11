#!/bin/bash
cd util/dayz_config/BattlEye/
echo "Updating util/dayz_config/BattlEye"
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariable.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariableval.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariablevar.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/setpos.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/mpeventhandler.txt
wget --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/setdamage.txt
