@echo off
cd deploy\Bliss\BattlEye
..\..\..\util\wget.exe --quiet -N http://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
echo Updated scripts.txt
..\..\..\util\wget.exe --quiet -N http://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
echo Updated remoteexec.txt
..\..\..\util\wget.exe --quiet -N http://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
echo Updated createvehicle.txt
