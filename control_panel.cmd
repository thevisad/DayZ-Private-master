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
echo 1 - Build Worlds
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
if %menuoption%==1 goto buildworlds
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
echo 1 - Chernarus
echo 2 - Utes
echo 3 - Thirsk
echo 4 - Thirskw
echo 5 - Celle
echo 6 - Lingor (Skaronator.com)
echo 0 - Back to menu
echo.
Set worldins=
set /p worldins=: 
if %worldins%==1 Set worldins = chernarus & goto addInstance
if %worldins%==2 Set worldins = utes & goto addInstance
if %worldins%==3 Set worldins = thirsk & goto addInstance
if %worldins%==4 Set worldins = thirskw & goto addInstance
if %worldins%==5 Set worldins = celle & goto addInstance
if %worldins%==6 Set worldins = skaro.lingor & goto addInstance
if %worldins%==9 goto moreworlds
if %worldins%==0 goto menu
cls
goto menu

:moreworlds
if not exist mysql.txt goto errsqlsetup
cls
echo Please give the world you want to add.
echo.
echo 1 - Taviana - Not Supported Yet
echo 2 - Takistan - Not Supported Yet
echo 3 - Fallujah - Not Supported Yet
echo 4 - Lingor - Not Supported Yet
echo 5 - Zargabad - Not Supported Yet
echo 6 - Panthera - Not Supported Yet
echo 8 - Goto Main
echo 9 - More Worlds
echo 0 - Back to menu
echo.
Set worldins=
set /p worldins=: 
if %worldins%==1 Set worldins = chernarus & goto addInstance
if %worldins%==2 Set worldins = utes & goto addInstance
if %worldins%==3 Set worldins = thirsk & goto addInstance
if %worldins%==4 Set worldins = thirskw & goto addInstance
if %worldins%==5 Set worldins = celle & goto addInstance
if %worldins%==6 Set worldins = skaro.lingor & goto addInstance
if %worldins%==8 goto instdb
if %worldins%==9 goto moreworlds
if %worldins%==0 goto menu
cls
goto menu

:addInstance
echo Adding instance...
db_utility.pl addinstance %worldins% --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport%
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

:buildworlds
cls
echo You are about to build a server package.
echo Make sure you have the requirements given in the readme before trying this.
echo.
echo Which world are you going to be using?
echo.
echo 1 - Chernarus
echo 2 - Utes
echo 3 - Thirsk
echo 4 - Thirskw
echo 5 - Celle
echo 6 - Lingor (Skaronator.com)
echo 9 - More Worlds
echo 0 - Back to menu
echo.
Set worldbuild=
Set choosenworld=
set /p worldbuild=: 
if %worldbuild%==1 Set choosenworld=chernarus & goto build2
if %worldbuild%==2 Set choosenworld=utes & goto build2
if %worldbuild%==3 Set choosenworld=thirsk & goto build2
if %worldbuild%==4 Set choosenworld=thirskw & goto build2
if %worldbuild%==5 Set choosenworld=mbg_celle2 & goto build2
if %worldbuild%==6 Set choosenworld=skaro.lingor & goto build2
if %worldbuild%==9 goto buildworlds1
if %worldbuild%==0 goto menu
cls
goto menu

:buildworlds1
cls
echo You are about to build a server package.
echo Make sure you have the requirements given in the readme before trying this.
echo.
echo Which world are you going to be using?
echo.
echo 1 - Taviana - Not Supported Yet
echo 2 - Takistan - Not Supported Yet
echo 3 - Fallujah - Not Supported Yet
echo 4 - Lingor - Not Supported Yet
echo 5 - Zargabad - Not Supported Yet
echo 6 - Panthera - Not Supported Yet
echo 8 - Goto Main Worlds Panel
echo 9 - More Worlds (Main Worlds Panel Currently)
echo 0 - Back to menu
echo.
Set worldbuild=
Set choosenworld=
set /p worldbuild=: 
if %worldbuild%==1 Set choosenworld=tavi & goto build2
if %worldbuild%==2 Set choosenworld=takistan & goto build2
if %worldbuild%==3 Set choosenworld=fallujah & goto build2
if %worldbuild%==4 Set choosenworld=lingor & goto build2
if %worldbuild%==5 Set choosenworld=zargabad & goto build2
if %worldbuild%==6 Set choosenworld=panthera2 & goto build2
if %worldbuild%==8 goto buildworlds
if %worldbuild%==9 goto buildworlds
if %worldbuild%==0 goto menu
cls
goto menu


:build2
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
echo Disable Server Simulation of Zombies? (ziellos2k)? (yes/no)
echo.
Set buildssZeds=
set /p buildssZeds=: 
cls
echo What should be the instance number? (1 is default)
echo.
Set buildinst=
set /p buildinst=: 
cls
echo You are about to build a %choosenworld% server with instance number %buildinst%, incl. the following packages:
echo.
echo Buildings: %buildbuildings%
echo Carepackages: %buildcarepkg%
echo Custom Inventroy: %buildinvcust%
echo Kill Messages: %buildkillmsg%
echo Messaging: %buildmsg%
echo Wrecks: %buildwreck%
echo ssZeds: %buildssZeds%
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
if %buildssZeds%==yes set buildss=--with-ssZeds
build.pl --world %choosenworld% --instance %buildinst% %buildbuild% %buildcare% %buildinv% %buildkill% %buildmes% %buildwrecks% %buildss%
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
echo 7 - Lingor (Skaronator.com)
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
if %scheme%==4 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityInvCust --version 0.02
if %scheme%==5 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityThirsk --version 0.01
if %scheme%==6 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityThirskWinter --version 0.01
if %scheme%==7 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealitySkaroLingor --version 0.01
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
