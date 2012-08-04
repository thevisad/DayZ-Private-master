@echo off
mkdir deploy\@Sanctuary\addons
mkdir deploy\MPMissions
util\cpbo.exe -y -p sanctuary\dayz_server deploy\@Sanctuary\addons\dayz_server.pbo
util\cpbo.exe -y -p sanctuary\missions\dayz.lingor deploy\MPMissions\dayz.lingor.pbo
util\cpbo.exe -y -p sanctuary\missions\dayz.chernarus deploy\MPMissions\dayz.chernarus.pbo
