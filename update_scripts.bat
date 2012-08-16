@echo off
cd deploy\Bliss\BattlEye
..\..\..\util\wget.exe -N http://dayz-community-banlist.googlecode.com/git/bans/bans.txt
..\..\..\util\wget.exe -N http://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
..\..\..\util\wget.exe -N http://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
..\..\..\util\wget.exe -N http://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
