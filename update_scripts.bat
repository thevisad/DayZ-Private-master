@echo off
cd deploy\Bliss\BattlEye
echo Changed to Bliss directory
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
echo Updated scripts.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
echo Updated remoteexec.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
echo Updated createvehicle.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariable.txt
echo Updated publicvariable.txt

cd ..\..\BlissLingor\BattlEye
echo Changed to BlissLingor directory
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
echo Updated scripts.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
echo Updated remoteexec.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
echo Updated createvehicle.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariable.txt
echo Updated publicvariable.txt
