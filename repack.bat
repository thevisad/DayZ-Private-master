@echo off
mkdir deploy\@Bliss\addons
mkdir deploy\@BlissLingor\addons
mkdir deploy\MPMissions
util\cpbo.exe -y -p bliss\dayz_server deploy\@Bliss\addons\dayz_server.pbo
util\cpbo.exe -y -p bliss\dayz_lingor deploy\@BlissLingor\addons\dayz_server.pbo
util\cpbo.exe -y -p bliss\missions\dayz.lingor deploy\MPMissions\dayz.lingor.pbo
util\cpbo.exe -y -p bliss\missions\dayz.chernarus deploy\MPMissions\dayz.chernarus.pbo
