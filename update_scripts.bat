@echo off
cd deploy\Bliss\BattlEye
echo Changed to Bliss directory
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariable.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariableval.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariablevar.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/setpos.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/mpeventhandler.txt

cd ..\..\BlissLingor\BattlEye
echo Changed to BlissLingor directory
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/scripts.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/remoteexec.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/createvehicle.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariable.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariableval.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/publicvariablevar.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/setpos.txt
..\..\..\util\wget.exe --quiet -N https://dayz-community-banlist.googlecode.com/git/filters/mpeventhandler.txt

echo Updated BE files!
