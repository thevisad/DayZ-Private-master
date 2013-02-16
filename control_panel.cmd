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
echo.                       Control Panel by gdscei and thevisad
echo.
echo.
echo Please select an option from the list below (type the number and press enter)
echo Did you download a new version? Goto setup options and run the migrate now!
echo.
echo 1 - Build Worlds
echo 2 - Vehicle/Deployable/Item Menu
echo 3 - Messages Menu
echo 4 - Clean up directories
echo 5 - Setup Options
echo 0 - Exit
echo.
Set menuoption=
set /p menuoption=: 
if %menuoption%==1 goto buildworlds
if %menuoption%==2 goto menumv
if %menuoption%==3 goto menumm
if %menuoption%==4 goto cleanup
if %menuoption%==5 goto menum1
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
echo.                       Control Panel by gdscei and thevisad
echo.
echo.
echo Please select an option from the list below (type the number and press enter)
echo (To build a server you first need to set up MySQL details)
echo.
echo.
echo 1 - Set up Perl
echo 2 - Set up MySQL details
echo 3 - Database Installation
REM echo 4 - Update Battleye scripts
echo 4 - Add instance to DB
echo 5 - Delete instance from DB
REM echo 6 - Delete all references to a world
echo 6 - Migrate from Bliss
echo 0 - Main menu
echo.
Set menuoption=
set /p menuoption=: 
if %menuoption%==1 goto perl
if %menuoption%==2 goto sqlsetup
if %menuoption%==3 goto schemaspec
REM if %menuoption%==4 goto 
if %menuoption%==4 goto instdb
if %menuoption%==5 goto deldb
REM if %menuoption%==7 goto 
if %menuoption%==6 goto mireality
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
echo.                       Control Panel by gdscei and thevisad
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
echo.                       Control Panel by gdscei and thevisad
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
echo.                       Control Panel by gdscei and thevisad
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
echo.                       Control Panel by gdscei and thevisad
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
echo.                       Control Panel by gdscei and thevisad
echo.
echo Please give the instance you want to delete.
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
db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealityMigrate --version 0.01
pause
goto menu

:cleanup
cls
build.pl --clean
pause
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
echo.                       Control Panel by gdscei and thevisad
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
echo 0 - Main Menu
echo.
Set worldbuild=
Set choosenworld=
set /p worldbuild=: 
if %worldbuild%==1 Set choosenworld=chernarus & goto buildins
if %worldbuild%==2 Set choosenworld=utes & goto buildins
if %worldbuild%==3 Set choosenworld=thirsk & goto buildins
if %worldbuild%==4 Set choosenworld=thirskw & goto buildins
if %worldbuild%==5 Set choosenworld=mbg_celle2 & Set buildcelle=yes & goto buildins
if %worldbuild%==6 Set choosenworld=skaro.lingor & goto buildins
if %worldbuild%==7 Set choosenworld=dayzplus & Set builddayzplus=yes & goto buildins
if %worldbuild%==0 goto menu
goto buildworlds

:buildins
cls
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
echo What do you want the instance number to be?
echo.
Set buildinst=
set /p buildinst=: 

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
echo.                       Control Panel by gdscei and thevisad
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
echo 0 - Main Menu
echo.
Set buildworldsswitch=
set /p buildworldsswitch=: 
if %buildworldsswitch%==1 (
if %buildbuildings%==no (
Set buildbuildings=yes & goto build2
) else (
Set buildbuildings=no & goto build2
)
)
if %buildworldsswitch%==2 (
if %buildcarepkg%==no (
Set buildcarepkg=yes & goto build2
) else (
Set buildcarepkg=no & goto build2
)
)
if %buildworldsswitch%==3 (
if %buildinvcust%==no (
Set buildinvcust=yes & goto build2
) else (
Set buildinvcust=no & goto build2
)
)
if %buildworldsswitch%==4 (
if %buildkillmsg%==no (
Set buildkillmsg=yes & goto build2
) else (
Set buildkillmsg=no & goto build2
)
)
if %buildworldsswitch%==5 (
if %buildmsg%==no (
Set buildmsg=yes & goto build2
) else (
Set buildmsg=no & goto build2
)
)
if %buildworldsswitch%==6 (
if %buildssZeds%==no (
Set buildssZeds=yes & goto build2
) else (
Set buildssZeds=no & goto build2
)
)
if %buildworldsswitch%==7 (
if %buildwreck%==no (
Set buildwreck=yes & goto build2
) else (
Set buildwreck=no & goto build2
)
)
if %buildworldsswitch%==8 goto build3
if %buildworldsswitch%==0 goto menu
goto build2

:build3
cls
echo Building server...
echo World: %choosenworld% >> build.txt
echo Instance: %buildinst% >> build.txt
if %buildbuildings%==yes set buildbuild=--with-buildings
echo Buildings: %buildbuildings% >> build.txt
if %buildcarepkg%==yes set buildcare=--with-carepkgs
echo Carepackage: %buildcarepkg% >> build.txt
if %buildinvcust%==yes set buildinv=--with-invcust
echo Custom inv: %buildinvcust% >> build.txt
if %buildkillmsg%==yes set buildkill=--with-killmsgs
echo Killmessages: %buildkillmsg% >> build.txt
if %buildmsg%==yes set buildmes=--with-messaging
echo Messaging: %buildmsg% >> build.txt
if %buildwreck%==yes set buildwrecks=--with-wrecks
echo Wrecks: %buildwreck% >> build.txt
if %buildssZeds%==yes set ssZeds=--with-ssZeds
echo ssZeds: %buildssZeds% >> build.txt
if %builddayzplus%==yes set dayzplus = --with-dayzplus
if %buildcelle%==yes set celle = --with-mbg_celle2
build.pl --world %choosenworld% --instance %buildinst% %buildbuild% %buildcare% %dayzplus% %buildinv% %buildkill% %buildmes% %buildwrecks% %ssZeds% %celle%
echo built --world %choosenworld% --instance %buildinst% %buildbuild% %buildcare% %dayzplus% %buildinv% %buildkill% %buildmes% %buildwrecks% %ssZeds% %celle% >> build.txt
echo.
echo Server has been built. Build.txt will contain a log of this.
pause
goto menu


:messagelist
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
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
echo Please type in the port of the DB.
echo.
Set hostport=
set /p hostport=: 
cls
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
echo Please type in the username of the DB.
echo.
Set hostun=
set /p hostun=: 
cls
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
echo Please type in the password of the DB.
echo.
Set hostpw=
set /p hostpw=: 
cls
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
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
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
echo Saved details. You can now use the DB features of this control panel.
pause
goto menu

:schemaspec
cls
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
echo Here you can select what you want to put into the DB.
echo.
echo 1 - Reality main (required)
echo 2 - RealityBuildings
echo 3 - RealityMessaging
echo 4 - RealityInvCust
echo 8 - World schemes
echo 9 - Back to menu
echo.
Set scheme=:
set /p scheme=: 
if %scheme%==8 goto schemaspec1
if %scheme%==9 goto menu
goto schemaspecs

:schemaspec1
cls
echo          _______  _______  _______  _       __________________         
echo         (  ____ )(  ____ \(  ___  )( \      \__   __/\__   __/^|\     /^|
echo         ^| (    )^|^| (    \/^| (   ) ^|^| (         ) (      ) (   ( \   / )
echo         ^| (____)^|^| (__    ^| (___) ^|^| ^|         ^| ^|      ^| ^|    \ (_) / 
echo         ^|     __)^|  __)   ^|  ___  ^|^| ^|         ^| ^|      ^| ^|     \   /  
echo         ^| (\ (   ^| (      ^| (   ) ^|^| ^|         ^| ^|      ^| ^|      ) (   
echo         ^| ) \ \__^| (____/\^| )   ( ^|^| (____/\___) (___   ^| ^|      ^| ^|   
echo         ^|/   \__/(_______/^|/     \^|(_______/\_______/   )_(      \_/   
echo.                       Control Panel by gdscei and thevisad
echo.
echo Here you can select what you want to put into the DB.
echo.
echo 1 - DayzPlus
echo 2 - Thirsk
echo 3 - Thirsk Winter
echo 4 - Lingor (Skaronator.com)
echo 8 - Other schemes
echo 9 - Back to menu
echo.
Set scheme=:
set /p scheme=: 
if %scheme%==8 goto schemaspec
if %scheme%==9 goto menu
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
if %scheme%==4 db_migrate.pl --host %hostdb% --user %hostun% --pass %hostpw% --name %hostnm% --port %hostport% --schema RealitySkaroLingor --version 0.01
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
