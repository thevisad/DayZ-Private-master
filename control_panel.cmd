@echo off

TITLE ^>^>Reality Control Panel^<^<
color 0A
if not exist db_utility.pl goto errfiles
if not exist build.pl goto errfiles
if not exist db_migrate.pl goto errfiles
if not exist db_spawn_vehicles.pl goto errfiles
echo Beginning build session > build.txt
:menu
cls
echo Setting up...

Set buildbuildings=no
Set buildcarepkg=no
Set buildinvcust=no
Set buildkillmsg=no
Set buildmsg=no
Set buildssZeds=no
Set buildwreck=no
Set builddayzplus=no
Set buildcelle=no


echo Getting MySQL info...
if not exist mysql.txt goto menum1
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
echo Did you download a new version? Goto setup options and run the migrate now!
echo.
echo 1 - Build Worlds
echo 2 - Vehicle/Deployable/Item Menu
echo 3 - Messages Menu
echo 7 - Clean up directories
echo 8 - Setup Options
echo 0 - Exit
echo.
Set menuoption=
set /p menuoption=: 
if %menuoption%==1 goto buildworlds
if %menuoption%==2 goto menumv
if %menuoption%==3 goto menumm
if %menuoption%==7 goto cleanup
if %menuoption%==8 goto menum1
if %menuoption%==0 exit
goto menu


:menum1
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
echo 1 - Set up Perl
echo 2 - Set up MySQL details
echo 3 - Database Installation
echo 4 - Update Battleye scripts
echo 5 - Add instance to DB
echo 6 - Delete instance from DB
echo 7 - Delete all references to a world
echo 8 - Migrate from Bliss
echo 0 - Main menu
echo.
Set menuoption=
set /p menuoption=: 
if %menuoption%==1 goto perl
if %menuoption%==2 goto sqlsetup
if %menuoption%==3 goto schemaspec
if %menuoption%==4 goto 
if %menuoption%==5 goto instdb
if %menuoption%==6 goto deldb
if %menuoption%==7 goto 
if %menuoption%==8 goto mireality
if %menuoption%==0 goto menu
goto menu


:menumv
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
echo 1 - Spawn Vehicles
echo 2 - Clean Vehicles
echo 3 - Clean Tents
echo 4 - Clean Bounds
echo 5 - Clean All
echo 6 - Clean Dead Survivors
echo 7 - Item Distribution
echo 8 - Clean Items
echo 0 - Main menu
echo.
Set menuoption=
set /p menuoption=: 
if %menuoption%==1 goto vehspawn
if %menuoption%==2 goto vehclean
if %menuoption%==3 goto tentsclean
if %menuoption%==4 goto boundsclean
if %menuoption%==5 goto allclean
if %menuoption%==6 goto survclean
if %menuoption%==7 goto itemdist
if %menuoption%==8 goto cleanitem
if %menuoption%==0 goto menu
goto menu

:menumm
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
echo 1 - Message List
echo 2 - Message Add
echo 3 - Message Edit
echo 4 - Message Delete
echo 0 - Main Menu
echo.
Set menuoption=
set /p menuoption=: 
if %menuoption%==1 goto messagelist
if %menuoption%==2 goto messageadd
if %menuoption%==3 goto messageedit
if %menuoption%==4 goto messagedel
if %menuoption%==0 goto menu
goto menu


:instdb
if not exist mysql.txt goto errsqlsetup
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
echo Please give the world you want to add.
echo.
echo 1 - Chernarus
echo 2 - Utes
echo 3 - Thirsk
echo 4 - Thirskw
echo 5 - Celle
echo 6 - Lingor (Skaronator.com)
echo 0 - Main Menu
echo.
Set worldins=
set /p worldins=: 
if %worldins%==1 Set worldins=chernarus & goto addInstance
if %worldins%==2 Set worldins=utes & goto addInstance
if %worldins%==3 Set worldins=thirsk & goto addInstance
if %worldins%==4 Set worldins=thirskw & goto addInstance
if %worldins%==5 Set worldins=celle & goto addInstance
if %worldins%==6 Set worldins=lingor & goto addInstance
if %worldins%==9 goto moreworlds
if %worldins%==0 goto menu
cls
goto menu

:moreworlds
if not exist mysql.txt goto errsqlsetup
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
echo Please give the world you want to add.
echo.
echo 1 - Taviana - Not Supported Yet
echo 2 - Takistan - Not Supported Yet
echo 3 - Fallujah - Not Supported Yet
echo 4 - Zargabad - Not Supported Yet
echo 5 - Panthera - Not Supported Yet
echo 8 - Goto Main
echo 9 - More Worlds
echo 0 - Main Menu
echo.
Set worldins=
set /p worldins=: 
if %worldins%==1 Set worldins=chernarus & goto addInstance
if %worldins%==2 Set worldins=utes & goto addInstance
if %worldins%==3 Set worldins=thirsk & goto addInstance
if %worldins%==4 Set worldins=thirskw & goto addInstance
if %worldins%==5 Set worldins=mbg_celle2 & goto addInstance
if %worldins%==8 goto instdb
if %worldins%==9 goto moreworlds
if %worldins%==0 goto menu
cls
goto menu

:addInstance
echo Adding instance...
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
db_utility.pl addinstance %worldins% --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport%
pause
goto menu

:deldb
if not exist mysql.txt goto errsqlsetup
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

:mireality
if not exist mysql.txt goto errsqlsetup
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
db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityMigrate --version 0.01
pause
goto menu

:cleanup
build.pl --clean
goto menu

:buildworlds
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
echo Which world are you going to be using?
echo.
echo 1 - Chernarus
echo 2 - Utes
echo 3 - Thirsk
echo 4 - Thirskw
echo 5 - Celle
echo 6 - Lingor (Skaronator.com)
echo 7 - Dayz+
echo 9 - More Worlds
echo 0 - Main Menu
echo.
Set worldbuild=
Set choosenworld=
set /p worldbuild=: 
if %worldbuild%==1 Set choosenworld=chernarus & goto build2
if %worldbuild%==2 Set choosenworld=utes & goto build2
if %worldbuild%==3 Set choosenworld=thirsk & goto build2
if %worldbuild%==4 Set choosenworld=thirskw & goto build2
if %worldbuild%==5 Set choosenworld=mbg_celle2 & goto build2
if %worldbuild%==6 Set choosenworld=lingor & goto build2
if %worldbuild%==7 Set choosenworld=dayzplus & goto build2
if %worldbuild%==9 goto buildworlds1
if %worldbuild%==0 goto menu
cls
goto menu

:buildworlds1
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
echo Which world are you going to be using?
echo.
echo 1 - Taviana - Not Supported Yet
echo 2 - Takistan - Not Supported Yet
echo 3 - Fallujah - Not Supported Yet
echo 4 - Zargabad - Not Supported Yet
echo 5 - Panthera - Not Supported Yet
echo 8 - Goto Main Worlds Panel
echo 9 - More Worlds (Main Worlds Panel Currently)
echo 0 - Main Menu
echo.
Set worldbuild=
Set choosenworld=
set /p worldbuild=: 
if %worldbuild%==1 Set choosenworld=tavi & goto build23
if %worldbuild%==2 Set choosenworld=takistan & goto build23
if %worldbuild%==3 Set choosenworld=fallujah & goto build23
if %worldbuild%==4 Set choosenworld=zargabad & goto build23
if %worldbuild%==5 Set choosenworld=panthera2 & goto build23
if %worldbuild%==8 goto buildworlds
if %worldbuild%==9 goto buildworlds
if %worldbuild%==0 goto menu
cls
goto menu


:build2
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
echo You are about to build a server package. Select your packages here. 
echo.
echo 1 - Buildings? %buildbuildings% (Place buildings on the map through DB)
echo 2 - Carepackages? %buildcarepkg% (Small packages with random loot on the map)
echo 3 - Custom inventory? %buildinvcust% (Get a custom starting inventory)
echo 4 - Kill messages? %buildkillmsg% (Kill messages in chat)
echo 5 - Messaging %buildmsg% (Send RCon messages in chat automaticly)
echo 6 - Disable Server Simulation of Zombies? (ziellos2k)? %buildssZeds% (Only spawn zombies client-side)
echo 7 - Wrecks? %buildwreck% (Random wrecks around the map with loot)
echo 8 - Build it!
echo 9 - More Packages
echo 0 - Main Menu
echo.
Set buildworldsswitch=
set /p buildworldsswitch=: 
if %buildworldsswitch%==1 Set buildbuildings=yes & echo hello
if %buildworldsswitch%==2 Set buildcarepkg=yes
if %buildworldsswitch%==3 Set buildinvcust=yes
if %buildworldsswitch%==4 Set buildkillmsg=yes
if %buildworldsswitch%==5 Set buildmsg=yes
if %buildworldsswitch%==6 Set buildssZeds=yes
if %buildworldsswitch%==7 Set buildwreck=yes
if %buildworldsswitch%==8 goto build3
if %buildworldsswitch%==9 goto build21
if %buildworldsswitch%==0 goto menu
cls
goto build2

:build21
cls
echo You are about to build a server package.
echo Make sure you have the requirements given in the readme before trying this.
echo.
echo Which world are you going to be using?
echo Buildings: %buildbuildings% Carepackages: %buildcarepkg% Custom Inv: %buildinvcust% Kill Msgs:%buildkillmsg% %buildmsg%
echo 1 - DayZPlus? (yes/no) (DayZ+ support)
echo 2 - Celle? (yes/no) (Celle support)
echo 8 - Build it!
echo 9 - More Packages
echo 0 - Main Menu
echo.
Set buildworldsswitch=
set /p buildworldsswitch=: 
if %buildworldsswitch%==1 Set builddayzplus=yes
if %buildworldsswitch%==2 Set buildcelle=yes
if %buildworldsswitch%==8 goto build3
if %buildworldsswitch%==9 goto build2
if %buildworldsswitch%==0 goto menu
cls
goto build21


:build3
echo What should be the instance number? (1 is default)
echo.
Set buildinst=
set /p buildinst=: 
cls

:build4
echo You are about to build a %choosenworld% server with instance number %buildinst%, incl. the following packages:
echo.
echo Buildings: %buildbuildings%
echo Carepackages: %buildcarepkg%
echo Custom Inventroy: %buildinvcust%
echo Kill Messages: %buildkillmsg%
echo Messaging: %buildmsg%
echo Wrecks: %buildwreck%
echo ssZeds: %buildssZeds%
echo DayZPlus: %builddayzplus%
echo Celle: %buildcelle%
echo.
echo If you do not wish to continue, please close the window. Else, press any key.
echo.
pause

echo Building server...
if %buildbuildings%==yes set buildbuild=--with-buildings
echo buildbuildings %buildbuildings%>> build.txt
if %buildcarepkg%==yes set buildcare=--with-carepkgs
echo buildcarepkg %buildcarepkg%>> build.txt
if %buildinvcust%==yes set buildinv=--with-invcust
echo buildinvcust %buildinvcust%>> build.txt
if %buildkillmsg%==yes set buildkill=--with-killmsgs
echo buildkillmsg %buildkillmsg% >> build.txt
if %buildmsg%==yes set buildmes=--with-messaging
echo buildmsg %buildmsg%>> build.txt
if %buildwreck%==yes set buildwrecks=--with-wrecks
echo buildwreck %buildwreck%>> build.txt
if %buildssZeds%==yes set ssZeds=--with-ssZeds
echo buildssZeds %buildssZeds%>> build.txt
if %builddayzplus%==yes set dayzplus = --with-dayzplus
echo builddayzplus %builddayzplus%>> build.txt 
if %buildcelle%==yes set celle = --with-mbg_celle2
echo buildcelle %buildcelle%>> build.txt
build.pl --world %choosenworld% --instance %buildinst% %buildbuild% %buildcare% %dayzplus% %buildinv% %buildkill% %buildmes% %buildwrecks% %ssZeds% %celle%
echo built --world %choosenworld% --instance %buildinst% %buildbuild% %buildcare% %dayzplus% %buildinv% %buildkill% %buildmes% %buildwrecks% %ssZeds% %celle% >> build.txt & pause
goto menu


:messagelist
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the search phrase (optional)
echo.
Set phrase=
set /p phrase=: 
cls
db_utility.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% messages list %phrase%
pause
goto menumm

:messageadd
if not exist mysql.txt goto errsqlsetup
cls 
echo Please specify the instance number
echo.
Set instn=
set /p instn=: 
cls
echo Please specify the start delay
echo.
Set startdelay=
set /p startdelay=: 
cls
echo Please specify the loop interval
echo.
Set looptime=
set /p looptime=: 
cls
echo Please specify the message
echo.
Set message=
set /p message=: 
cls
db_utility.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% messages add %instn% %startdelay% %looptime% %message%
pause
goto menumm

:messageedit
if not exist mysql.txt goto errsqlsetup
cls 
echo Please specify the instance number
echo.
Set instn=
set /p instn=: 
cls
echo Please specify the Message ID
echo.
Set messageid=
set /p messageid=: 
cls
echo Please specify the start delay
echo.
Set startdelay=
set /p startdelay=: 
cls
echo Please specify the loop interval
echo.
Set looptime=
set /p looptime=: 
cls
echo Please specify the message
echo.
Set message=
set /p message=: 
cls
db_utility.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% messages edit %messageid% %instn% %startdelay% %looptime% %message%
pause
goto menumm

:messagedel
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the message ID
echo.
Set messageid=
set /p messageid=: 
cls
db_utility.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% messages del %messageid%
pause
goto menumm

:vehspawn
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the instance number (default is 1)
echo.
Set instn=
set /p instn=: 
cls
db_spawn_vehicles.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% 
pause
goto menumv

:vehclean
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the instance number (default is 1)
echo.
Set instn=
set /p instn=: 
cls
db_spawn_vehicles.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% --cleanup damaged
pause
goto menumv

:tentsclean
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the instance number (default is 1)
echo.
Set instn=
set /p instn=: 
cls
db_spawn_vehicles.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% --cleanup tents
pause
goto menumv

:boundsclean
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the instance number (default is 1)
echo.
Set instn=
set /p instn=: 
cls
db_spawn_vehicles.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% --cleanup bounds
pause
goto menumv

:allclean
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the instance number (default is 1)
echo.
Set instn=
set /p instn=: 
cls
db_spawn_vehicles.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% --cleanup all 
pause
goto menumv

:survclean
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the instance number (default is 1)
echo.
Set instn=
set /p instn=: 
cls
echo Please specify the number of days to clean
Set daystoClean=
set /p daystoClean=: 
cls
db_utility.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% --cleandead %daystoClean%
pause
goto menu

:cleanitem
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the instance number (default is 1)
echo.
Set instn=
set /p instn=: 
cls
echo Please specify the items to clean (seperated by a comma)
echo.
Set itemtoclean=
set /p itemtoclean=: 
cls
db_utility.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% --cleanitem %itemtoclean%
pause
goto menu

:itemdist
if not exist mysql.txt goto errsqlsetup
cls
echo Please specify the instance number (default is 1)
echo.
Set instn=
set /p instn=: 
cls
db_utility.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --instance %instn% --itemdistr
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
echo 8 - Back to menu
echo 9 - Goto Schema Page 2
echo.
Set scheme=:
set /p scheme=: 
if %scheme%==8 goto menu
if %scheme%==9 goto schemaspec1
goto schemaspecs

:schemaspec1
cls
echo Here you can select what you want to put into the DB.
echo.
echo 1 - DayzPlus
echo 2 - Thirsk
echo 3 - Thirsk Winter
echo 4 - Lingor (Skaronator.com)
echo 8 - Back to menu
echo 9 - Goto Schema Page 1
echo.
Set scheme=:
set /p scheme=: 
if %scheme%==8 goto menu
if %scheme%==9 goto schemaspec
goto schemaspecs1

:schemaspecs
cls
if %scheme%==1 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport%
if %scheme%==2 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityBuildings --version 0.01
if %scheme%==3 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityMessaging --version 0.01
if %scheme%==4 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityInvCust --version 0.02

pause
goto schemaspec

:schemaspecs1
cls
if %scheme%==1 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityDayzPlus --version 0.01
if %scheme%==2 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityThirsk --version 0.01
if %scheme%==3 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityThirskWinter --version 0.01
if %scheme%==4 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema Reality --version 0.39
pause
goto schemaspec1

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
