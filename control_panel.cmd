@echo off
title ^>^>Reality Control Panel^<^<
color 0A
if not exist db_utility.pl goto errfiles
if not exist build.pl goto errfiles
if not exist db_migrate.pl goto errfiles
if not exist db_spawn_vehicles.pl goto errfiles
:menu
cls
echo Setting up...
echo Getting MySQL info...
if not exist mysql.txt goto menum
for /f "delims=" %%a in ('findstr /b "host:" mysql.txt') do set hostdb=%%a
set hostdb=%hostdb:~5%
for /f "delims=" %%a in ('findstr /b "port:" mysql.txt') do set hostport=%%a
set hostport=%hostport:~5%
for /f "delims=" %%a in ('findstr /b "user:" mysql.txt') do set hostun=%%a
set hostun=%hostun:~5%
for /f "delims=" %%a in ('findstr /b "pass:" mysql.txt') do set hostpw=%%a
set hostpw=%hostpw:~5%
for /f "delims=" %%a in ('findstr /b "name:" mysql.txt') do set hostnm=%%a
set hostnm=%hostnm:~5%
:menum
cls
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                            Control Panel by gdscei
echo.
echo.
echo Please select an option from the list below (type the number and press enter)
echo.
echo.
echo 1 - Build
echo 2 - Spawn Vehicles
echo 3 - Database Migration
echo 4 - Set up Perl
echo 5 - Set up MySQL details
echo 6 - Migrate from Bliss
echo 7 - Add instance to DB
echo 8 - Delete instance from DB
echo 9 - Exit
echo.
Set menuoption=
set /p menuoption=: 
if %menuoption%==1 goto build
if %menuoption%==2 goto vehspawn
if %menuoption%==3 goto schemaspec
if %menuoption%==4 goto perl
if %menuoption%==5 goto sqlsetup
if %menuoption%==6 goto mibliss
if %menuoption%==7 goto instdb
if %menuoption%==8 goto deldb
if %menuoption%==9 exit
goto menu

:instdb
if not exist mysql.txt goto errsqlsetup
cls
echo Please give the world you want to add.
echo.
echo chernarus - skaro.lingor - utes
echo thirsk - thirsk winter
echo.
Set worldins=
set /p worldins=: 
cls
echo Adding instance...
db_utility.pl addworld %worldins% --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport%
pause
goto menu

:deldb
if not exist mysql.txt goto errsqlsetup
cls
echo Please give the instance you want to delete.
echo.
echo 1 - ??
echo.
Set instance=
set /p instance=: 
cls
echo Deleting instance...
db_utility.pl deleteinstance %instance% --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport%
pause
goto menu

:mibliss
if not exist mysql.txt goto errsqlsetup
cls
db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityMigrate --version 0.01
pause
goto menu

:build
cls
echo You are about to build a server package.
echo Make sure you have the requirements given in the readme before trying this.
echo.
echo Which world are you going to be using?
echo.
echo chernarus - skaro.lingor - utes
echo thirsk - thirsk winter
echo.
Set worldbuild=
set /p worldbuild=: 
cls
echo Which packages do you want?
echo.
echo Buildings? (yes/no)
echo.
Set buildbuildings=
set /p buildbuildings=: 
cls
echo Carepackages? (yes/no)
echo.
Set buildcarepkg=
set /p buildcarepkg=: 
cls
echo Custom inventory? (yes/no)
echo.
Set buildinvcust=
set /p buildinvcust=: 
cls
echo Kill messages? (yes/no)
echo.
Set buildkillmsg=
set /p buildkillmsg=: 
cls
echo Messaging? (yes/no)
echo.
Set buildmsg=
set /p buildmsg=: 
cls
echo Wrecks? (yes/no)
echo.
Set buildwreck=
set /p buildwreck=: 
cls
echo What should be the instance number? (1 is default)
echo.
Set buildinst=
set /p buildinst=: 
cls
echo You are about to build a %worldbuild% server with instance number %buildinst%, incl. the following packages:
echo.
echo Buildings: %buildbuildings%
echo Carepackages: %buildcarepkg%
echo Custom Inventroy: %buildinvcust%
echo Kill Messages: %buildkillmsg%
echo Messaging: %buildmsg%
echo Wrecks: %buildwreck%
echo.
echo If you do not wish to continue, please close the window. Else, press any key.
echo.
pause
cls
echo Building server...
if %buildbuildings%==yes set buildbuild=--with-buildings
if %buildcarepkg%==yes set buildcare=--with-carepkgs
if %buildinvcust%==yes set buildinv=--with-invcust
if %buildkillmsg%==yes set buildkill=--with-killmsgs
if %buildmsg%==yes set buildmes=--with-messaging
if %buildwreck%==yes set buildwrecks=--with-wrecks
build.pl --world %worldbuild% --instance %buildinst% %buildbuild% %buildcare% %buildinv% %buildkill% %buildmes% %buildwrecks%
pause
goto menu

:vehspawn
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the instance number (default is 1)
echo.
Set instn=
set /p instn=: 
cls
db_spawn_vehicles.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% --cleanup bounds
pause
goto menu

:sqlsetup
cls
echo You are about to set up the SQL details to let the Control Panel connect to the DB.
echo Note: these details will be stored in a text file in the current folder to use again.
echo.
echo.
echo Please type in the host ip address or type 1 to make it localhost.
echo.
Set hostdb=
set /p hostdb=: 
if %hostdb%==1 set hostdb=127.0.0.1
cls
echo Please type in the port of the DB.
echo.
Set hostport=
set /p hostport=: 
cls
echo Please type in the username of the DB.
echo.
Set hostun=
set /p hostun=: 
cls
echo Please type in the password of the DB.
echo.
Set hostpw=
set /p hostpw=: 
cls
echo Please type in the name of the DB.
echo.
Set hostnm=
set /p hostnm=: 
cls
echo Writing to file...
if exist mysql.txt del mysql.txt
echo host:%hostdb% >> mysql.txt
echo port:%hostport% >> mysql.txt
echo user:%hostun% >> mysql.txt
echo pass:%hostpw% >> mysql.txt
echo name:%hostnm% >> mysql.txt
cls
echo Written to file. You can now use the DB features of this control panel.
pause
goto menu

:schemaspec
cls
echo Here you can select what you want to put into the DB.
echo.
echo 1 - Reality main (required)
echo 2 - RealityBuildings
echo 3 - RealityMessaging
echo 4 - RealityInvCust
echo 5 - Thirsk
echo 6 - Thirsk Winter
echo 7 - Lingor (Skaro)
echo 8 - Back to menu
echo.
Set scheme=:
set /p scheme=: 
if %scheme%==8 goto menu
goto schemaspecs

:schemaspecs
cls
if %scheme%==1 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport%
if %scheme%==2 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityBuildings --version 0.01
if %scheme%==3 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityMessaging --version 0.01
if %scheme%==4 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityInvCust --version 0.01
if %scheme%==5 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityThirsk --version 0.01
if %scheme%==6 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityThirskWinter --version 0.01
if %scheme%==7 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityLingorSkaro --version 0.01
pause
goto schemaspec

:perl
cls
call setup_perl.bat
pause
goto menu

:cleantmp
cls
perl build.pl --clean
pause
goto menu

:errfiles
cls
echo You are missing one or more Reality files. Please make sure this utility is in the same directory as files such as db_utility.pl and build.pl.
pause
exit

:errsqlsetup
cls
echo The option you want requires you to set-up your MySQL database details. You can do this by pressing any key now.
echo.
pause
goto sqlsetup