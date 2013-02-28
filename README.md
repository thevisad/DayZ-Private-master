DayZ Reality Private Server
=========================

This is a private server project for DayZ which would not be possible without the work of Rocket, Guru Abdul and ayan4m1.   
**NOTE**: No support is implied or offered for pirated copies of ArmA 2.

Users Migrating from Bliss
==========================
Users migrating from Bliss to Reality using an existing database will need to run the "Migrate from Bliss" option in the "Setup / DB"->"Database" window.

Users of command line or bash may use this comment as an alternative. 

db_migrate.pl --host yourdatabaseip --user changeme --pass changeme --name yourdatabasename --port 3306 --schema RealityMigrate --version 0.01

GitHub Support Issues
=====================
When submitting a github issue please add all of the following information. Failure to do so will cause your support ticket to be delayed or worse, closed without resolution.

In order to obtain your HiveEXT version, right click on the file and choose properties, then choose details. You will want to provide File Version and Product version.

To obtain your MySQL version type **mysql --version** at the command line.

Downloads for dayz_server.pbo and mission pbo are only required for servers running into issues with the server running after a successful compile.<br>

Service Provider:<br>
Server Type (dedicated, vps, dayz server only):<br>
World Name:<br>
Reality branch(1.7.5 or 1.7.6):<br>
DayZ_Code version:<br>
Download for RPT/HiveLog:<br>
Download for dayz_server.pbo/mission.pbo:<br>
HiveEXT.DLL version:<br>
MySQL Version: <br>
Server name: <br>
Deatiled description of issue:<br>


MYSQL Security
==============
It is highly suggested that the user account that is used for the DayZ server is not the same as your root account. This account should **NOT** have access to drop tables and only have the Insert, Update, Select or Execute priveledges and **ONLY** for the DayZ database.

MySQL Setup
===========
Please go watch this video in order to understand how to setup your MySQL database properly. https://www.youtube.com/watch?v=hLxOT6BqA5I
Please go watch this video in order to understand how to setup MySQL Workbench properly (note this shows workbend as a seperate download and install). https://www.youtube.com/watch?v=SDorsBiNH54

Database Schema 0.39+
=====================
Starting with database schema 0.39+ (Oring support) we will be reseting portions of the vehicle tables. The resets are part of trying to resolve multiple issues with the old database schemas. Any custom added vehicles will need to be moved prior to update due to the refactoring of the vehilce numbers. It is suggested that custom vehicles be given a number higher then 1000 to leave room for any and all maps that will be added in the future. 

We understand that this may be inconvienent for admins who have hand done large portions of vehicles; however, we feel that this will better support all users of this software in the long run and allow maps to be ported faster to the Reality system. 


Scripts Conversions
===================
Adding in your own scripts every time you compile a world can be a pain. Especially if the world you are hoping to support has a large number of scripts. I have created the RealityScriptEncoder to handle this aspect for you. 

Find the script line that contains the item you wish to add as a filter. Namalsk added a large number of scripts for 1.7.5.1, we will use this as an example. 

1. Find line skipTime ( this differs from the community scripts )and add that text script item text box. 
2. Find the difference from the community filters (use a diff program like Beyond Compare). You will find the difference in this line is !"skipTime _posun;"
3. Add this line to the Script text textbox and click DoIt! The program will output the line as "skipTime": "!\\\"skipTime _posun;\\\""
4. Open the \filter\namalsk filter (this has already been done for you if you are using the latest) and add this line as a new line in between the brackets.
5. Test your new script implementation, this line will now automatically be added to the end of any community scripts that are downloaded during the build process.


Prerequisites
=============

 - Windows (tested with 7 and Server 2008)
 - A working ArmA 2 Combined Ops dedicated server (Steam users must merge ArmA2 and ArmA2 OA directories) with beta patch **102285+** installed (http://www.arma2.com/beta-patch.php)
 - Microsoft Visual C++ 2010 SP1 x86 Redistributable (http://www.microsoft.com/en-us/download/details.aspx?id=8328)
 - Microsoft .NET Framework 4 or higher
 - MySQL Server 5.x with TCP/IP Networking enabled **NOTE:** You **must** use the official MySQL installer, not XAMPP (http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.27-win32.msi/from/http://cdn.mysql.com)
 - The decimal separator on your server MUST BE a period. If it is a comma, vehicle spawning (at least) will not work correctly. **NOTE:** If you use FireDaemon to start your server, you must re-create the service if you change the comma separator in Windows.
 - Strawberry Perl 32 Bit (NOT 64 Bit)>= 5.16 (http://strawberryperl.com/) (64 bit does not have all the dependencies properly setup)
 - DayZ 1.7.6.1 client (http://cdn.armafiles.info/latest/1.7.6/) 

Directories
===========

**IMPORTANT**: When you see the following names in bold, substitute in the appropriate path as described.

 - **ArmA2** - this is the root directory of your ArmA 2 installation.
 - **Repository** - this is the directory you have extracted (or cloned) these private server files to.
 - **Config** - this is a directory called `dayz_<id>.<world>` created during deployment. Replace `<id>` with the instance ID and `<world>` with the world you specified when running build.pl.

Installation
============

**NOTE**: The importance of following each of these steps correctly and in order cannot be understated. 
**NOTE**: It is highly recommended to disable UAC during the install portion; especially, the perl setup portion. Right clicking and running as Administration **DOES NOT WORK PROPERLY*** due to the way that the Perl setup application works. 

Automatic installation
======================

1. Run the RealityCP program. This is an UI replacement for the command-line, command line functions still work; however, this was added to ease support questions.
2. Upon opening the app, you will be prompted entering your MySQL details. Make sure you've got a database set up and enter the details in the window (to set up a database, you can use a graphical interface such as HeidiSQL (http://www.heidisql.com).
3. Begin by clicking "Setup / DB" and "Set-Up Perl". This will get Perl ready on your Reality package.
4. After that, click 'Build'. Here you actually set-up the build files for your server. You'll find them in the 'deploy' folder after finishing. If you need info on what packages do, click the "?" button.
5. Copy all files from **Repository**\\deploy into **ArmA2**\\
6. Make sure you also have the required client files in the **ArmA2**\\ directory. Check below for a table with download links.
7. Now choose 'Setup / DB' and "Database". Here you can select packages for your database in the 'Import scheme' list. Note that Reality Main is required. If you installed any packages during build, you'll need to put them in the database as well. (e.g: you ran the build with Buildings, you need to import the Buildings scheme as well)
8. Also add an instance with the correct world from the same window, if you're not using Chernarus.
9. If you'd like to change server time/date, change the options in **Config**\\HiveExt.ini
10. Adjust any server settings (name, password etc) in **Config**\\config_deadbeef.cfg (deadbeef is a randomly generated string)
11. If you would like to customize the starting loadout, it is highly recommended that you use the Reality Inventory manager located here http://opendayz.net/index.php?threads/reality-dayz-inventory-manager-c.6835/


Manual installation (advanced)
===================

1. Run `setup_perl.bat`. If you are prompted to provide a schema path, press enter to continue. If you are prompted Yes/No to run tests, type "n" and press Enter.  
2. Run `perl build.pl --world <world> --instance <id>` in **Repository**, replacing `<world>` with a valid world name and `<id>` with an integer representing the instance ID. If you only run one server, you may omit the `--instance` parameter from the command. If --world is omitted, the default is Chernarus. Use `perl build.pl --list` to get a list of available worlds and optional packages and run `perl build.pl --help` for additional information on how to use build.pl.  
3. Copy all files from **Repository**\\deploy into **ArmA2**\\  
4. For this step, you will need to use one of several MySQL administrative utilities to execute some SQL queries. These utilities include the MySQL Command Line Interface (which is bundled with the MySQL Server install for Windows) and various free and commercial GUI utilities. We recommend HeidiSQL if you want a graphical interface (http://www.heidisql.com/). Once you have connected to your database as the **root** user (you set the password for this user when you installed MySQL Server), execute the following SQL queries (be **sure** to change the password in the second query from CHANGEME):  

		create database dayz;
		create user 'dayz'@'localhost' identified by 'CHANGEME';
		grant all privileges on dayz.* to 'dayz'@'localhost';

5. Run `perl db_migrate.pl --password CHANGEME` from the **Repository** directory. Replace `CHANGEME` with the password you chose in the previous step. Use the `--help` flag to get more information on how to set the hostname, username, or database name to suit your needs.  
6. Ensure that the database information in **Config**\\HiveExt.ini match the database details you used in the previous step.  
7. If you would like to customize the server time, change the pertinent options in **Config**\\HiveExt.ini.  
8. Adjust server name/passwords as desired in **Config**\\config_deadbeef.cfg. (deadbeef is a randomly generated string)
9. If you would like to customize the starting loadout, it is highly recommended that you use the Reality Inventory manager located here http://opendayz.net/index.php?threads/reality-dayz-inventory-manager-c.6835/  You may also run `perl db_utility.pl loadout <inventory> <backpack>`, replacing `<inventory>` with a valid inventory string and `<backpack>` with a valid backpack string. We will **NOT** support users who attempt to manually create inventory or backpack strings due to complexity of the strings. Some examples:  

<table>
  <tr>
    <td>Description</td><td>Inventory</td><td>Backpack</td>
  </tr>
  <tr>
    <td>Default</td><td>[]</td><td>["DZ_Patrol_Pack_EP1",[[],[]],[[],[]]]</td>
  </tr>
  <tr>
    <td>Survival</td><td>[["ItemMap","ItemCompass","ItemMatchbox","FoodCanBakedBeans","ItemKnife","FoodCanBakedBeans"],["ItemTent","ItemBandage","ItemBandage"]]</td><td>["DZ_Patrol_Pack_EP1",[[],[]],[[],[]]]</td>
  </tr>
  <tr>
    <td>PvP</td><td>[["Mk_48_DZ","NVGoggles","Binocular_Vector","M9SD","ItemGPS","ItemToolbox","ItemCompass","FoodCanBakedBeans","ItemMap","ItemWatch"],[["100Rnd_762x51_M240",47],"ItemPainkiller","ItemBandage","15Rnd_9x19_M9SD","100Rnd_762x51_M240","ItemBandage","ItemBandage","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","ItemMorphine"]]</td><td>["DZ_Backpack_EP1",[[],[]],[[],[]]]</td>
  </tr>
</table>
10. Ensure the required client mods are present in **ArmA2**\\. Refer to the following table for specific information based on your desired world.  
<table>
  <tr>
    <td>World</td><td>World Name (Database)</td><td> World ID</td><td>Mod Folders</td><td>Version</td><td>Download</td>
  </tr>
  <tr>
    <td>Chernarus</td><td>chernarus</td><td>1</td><td>@dayz</td><td>1.7.6.1</td><td><b><a href="http://cdn.armafiles.info/latest/1.7.6/%40Server-1.7.6.1-Full.rar" >RAR</a></b></td>
  </tr>
  <tr>
    <td>DayZ Lingor Island</td><td>lingor</td><td>2</td><td>@dayzlingorskaro</td><td>2.1</td><td><b><a href="http://dl.skaronator.com/DayZLingorSkaro-2.1.rar" >RAR</a></b></td>
  </tr>
  <tr>
    <td>Utes</td><td>utes</td><td>3</td><td>@dayz</td><td>1.7.6.1</td><td><b><a href="http://cdn.armafiles.info/latest/1.7.6/%40Server-1.7.6.1-Full.rar" >RAR</a></b></td>
  </tr>
   <tr>
    <td>DayZ Invasion 1944</td><td>i44.chernarus</td><td>17</td><td>@DayZ_i44 @I44 @CBA @CBA_A2 @CBA_OA @CBA_CO</td><td>0.2.0</td><td><b><a href="http://dl.skaronator.com/DayZInvasion-0.2.0.zip" >ZIP</a></b></td>
  </tr>
</table>
11. If you are using a world other than Chernarus, run `perl db_utility.pl setworld <world_name>`, where `<world_name>` is the name of the world you specified when running `build.pl`.
12. Run **ArmA2**\\Restarter.exe to start the server.  


Adding/Removing Instances
=========================

You can add/remove instances from the RealityCP application (from Setup/DB->Database). This will allow server owwners to utilize the database for more then a single instance of a map.


Upgrading
=========

Depending on what has changed since you deployed your server, you may need to perform one or more steps to do a clean upgrade to the latest code. Look for the following in the commit log (specifically, the files that were changed) when you update to the latest version of the repository:

If you see that SQL files or `db_migrate.pl` have changed, then you **must** do "Import Scheme" on 'Reality Main' in the "Setup / DB"->"Database" window of the application to update your database.
If SQF files (game script) has changed, then you **must** rebuild your server from the application and copy the `**Repository**\\deploy\\@reality_<id>.<world>\\` directory into **ArmA2**\\ (where `<id>` and `<world>` are the values you specified when building).
If configuration files and BattlEye anti-cheat files have changed in **Repository**\\deploy\\, you will need to backup and overwrite your existing versions of these files. Take care to change any default server names, passwords or similar back to their customized values after copying the new versions into your **ArmA2** directory.
If you receive an error like `Cannot locate Some::Module.pm in @INC` when trying to do anything in the application, you need to change the application's config file (RealityCP.exe.config) and make the "perl" value (where it says "done") empty, and then run the Set-up Perl again from the app.

These are the areas you will need to inspect to ensure a smooth upgrade. If database and code changes were not made at the same time and you do not read the history thoroughly, you may miss important changes and skip vital steps. It will save you frustration in the long run if you rebuild and redeploy, re-run the Reality Main scheme and check for any new or changed files in **Repository**\\deploy\\ whenever you would like to update.

Vehicles
========

You can spawn vehicles / cleanup tents/vehicles/bounds etc from the application. For spawning vehicles, go to "Vehicles/Items", for cleaning anything, go to "Cleanup".

**NOTE:** Vehicles added/updated via database manipulation are only available after a server restart.

Optional Features
=================

You can enable custom packages when building your server files.
A list of Reality-supported packages follows.

<table>
  <tr>
    <td>Name</td><td>Param</td><td>Description</td>
  </tr>
  <tr>
    <td>carepkgs</td><td>--with-carepkgs</td><td>Drops care packages with various loot types across the map (similar to heli crash sites)</td>
  </tr>
  <tr>
    <td>killmsgs</td><td>--with-killmsgs</td><td>Shows in-game messages when one player kills another (not needed for Lingor). Custom BE filters must be used (Download Pending)</td>
  </tr>
  <tr>
    <td>messaging</td><td>--with-messaging</td><td>Replacement for the old scheduler feature, see <b>Messaging/Scheduler</b> below</td>
  </tr>
  <tr>
    <td>buildings</td><td>--with-buildings</td><td>Allow spawning of database-defined structures/buildings on the map, see <b>Buildings</b></td>
  </tr>
  <tr>
    <td>wrecks</td><td>--with-wrecks</td><td>Spawns various lootable vehicle wrecks across the map on server start</td>
  </tr>
  <tr>
    <td>invcust</td><td>--with-invcust</td><td>Allows you to grant custom spawn loadouts to individuals or group, see <b>Custom Inventory</b></td>
  </tr>
  <tr>
    <td>mbg_celle2</td><td>--with-mbg_celle2</td><td>Server-pbo modifications/fixes for celle</b></td>
  </tr>
  <tr>
    <td>ssZeds</td><td>--with-ssZeds</td><td>Disable server-side zombie simulation (may improve server FPS)</td>
  </tr>
  <tr>
    <td>ssZedsMessaging</td><td>--with-ssZedsMessaging</td><td>Disable server-side zombie simulation (may improve server FPS) AND the Messaging package all rolled into one. if you want both packages, please use this one so there are no merging issues.</td>
  </tr>
</table> 

Multiple Instances
==================

You can run multiple server instances connected to the same database to provide a private cluster of servers all using the same character information.
 
1. Build server files using the application, make sure to note the Instance number.
2. Go to "Setup / DB"->"Database" and add the instance with the appropriate world. You might need to change the ID number manually in the database.

Care must be taken to ensure that all paths and options have been set correctly. With this system you can run as many instances as your server can support simultaneously.

Messaging / Scheduler
=====================

You may optionally enable an in-game announcement system for Reality. To do so, follow these steps:

1. Go into the RealityCP application, select "Setup / DB"->"Database", and import the Messaging scheme.
2. Make sure to have build Reality with the Messaging package.
3. From the main menu of the application, go to "Messaging" to add, edit, remove or list messages.

**NOTE:** Messages added/updated via database manipulation are only available after a server restart.

Buildings
=========

You may optionally enable a system that reads structure information from the database and spawns a set of static structures on the map on each server start. To do so, follow these steps:

1. Go into the RealityCP application, select "Setup / DB"->"Database", and import the Buildings scheme.
2. Make sure to have build Reality with the Buildings package.
3. You can insert buildings manually in the database with their class names in the building table and then insert the coordinates / IDs in the instance_building table.

**NOTE:** Buildings added/updated via database manipulation are only available after a server restart.

Custom Inventory
================

You may optionally enable a system that allows you to define custom spawn loadouts for individuals and/or group. To do so, follow these steps:

1. Go into the RealityCP application, select "Setup / DB"->"Database", and import the Custom Inventory scheme.
2. Make sure to have build Reality with the Custom Inventory package.  

There are two tables which you must insert values into to use this feature. The `cust_loadout` table defines unique sets of inventory/backpack to give the player(s) on spawn. The `cust_loadout_profile` table then ties these cust_loadout rows to player profile IDs. You can associate multiple profile IDs to a single loadout with this relationship.

ssZeds - Zeelios2k
==================
 This package originally started on the DayZMod github and was created by Zellios2k. This disables the server simulation of zombies and allows the client to handle this aspect. This frees up cpu cycle on the server and provides a serious FPS boost on some servers. 

Customization
=============

Here are the most common customization requests with instructions.

**Request**: I would like to change the available chat channels.  
**Solution**: When running `build.pl`, add the `--channels <channel>` option, where `<channel>` is a comma-separated list of chat channel numbers, which will be **DISABLED**. Refer to http://community.bistudio.com/wiki/Description.ext#disableChannels for a mapping of channel names to numbers.

**Request**: I would like to alter difficulty options (3rd-person, crosshairs, name tags, etc).  
**Solution**: Edit **Config**\\Users\\Reality\\Reality.ArmA2OAProfile. An explanation of the options is available at http://community.bistudio.com/wiki/server.armaprofile. You must restart the server for these changes to take effect.

Gotchas / Known Bugs
==========

Character data can become desynchronized if the player was connected within several minutes of server shutdown. A heavily loaded server will continue processing backlogged player syncs for some time even after all players have been disconnected. We strongly recommend that you wait 5 minutes after all players have disconnected before shutting down a public server.

Any bug present in the official client or server will probably also exist in this solution. Please do **not** report these as issues on GitHub.

Common Issues
=============

**Problem**: You get errors referring to `libmysql_.dll` or see errors indicating a missing `DBD/mysql.pm` or `DBD::mysql` when running db_migrate.pl or db_spawn_vehicles.pl.  
**Solution**: Use Strawberry Perl instead of ActivePerl. If that does not resolve the issue, try running `cpan DBD::mysql` in a command prompt or adding your Perl bin directory to the PATH environment variable.

**Problem**: You get an error like `Cannot locate Some::Module.pm in @INC` when running a Perl script.  
**Solution**: Run `setup_perl.bat` and try to execute the Perl script again. Also, do not right click and say run as administrator - this will **NOT** work. You should disable UAC for the insstall,once installed, you may reenable UAC if you wish.

**Problem**: "Error Connecting to Service" / Stuck at Loading / Errors in **arma2oaserver.rpt**  
**Solution**: Look in **Config**\\hiveext.log for MySQL connection errors (Google these to find troubleshooting steps). If you do not have a **Config**\\hiveext.log file, right-click on `HiveExt.dll` in `@Reality` (`@RealityLingor` for Lingor servers) and select Properties. If you see an Unblock button, click it and hit OK. Ensure you have a valid MySQL user created, have run db_migrate.pl successfully, have set all options correctly in **Config**\\HiveExt.ini and that you can run the following when logged in to MySQL:  

	select * from survivor;

**Problem**: Server crashes when the first player connects  
**Solution**: Ensure that you have `HiveEXT.dll` in your **ArmA2**\\@reality_\<instance\>.\<world\> directory and that you have a valid and well-formed **Config**\\HiveExt.ini. Also ensure that you have tried both `localhost` and `127.0.0.1` as the hostname if you run MySQL on the same server as Reality. Ensure that all Schemas have been imported properly for the packages you are working with. 

**Problem**: Server not listed on GameSpy in-game server list or third-party server lists  
**Solution**: Ensure the game ports (default 2302 - 2305 UDP) are forwarded properly and that the GameSpy master server is up and running.  

**Problem**: "Bad CD Key" messages  
**Solution**: Run both Arma 2 and Arma 2 OA and at least get to the main menu. This will set your key in the registry and allow the beta patches to install properly. 

Source code
===========

Source for the Hive is available at: https://github.com/thevisad/Hive

Source for the RealityCP is available at: https://github.com/gdscei/RealityCP

Thanks To
=========

Each of these packages is a part of Reality and makes what we do possible.

<table>
  <tr><th>Name</th><th>Author</th><th>URL</th></tr>
  <tr><td>cPBO</td><td>Kegetys</td><td>http://www.kegetsys.fi</td></tr>
  <tr><td>GnuWin32 (wget/sed)</td><td></td><td>http://gnuwin32.sourceforge.net</td></tr>
  <tr><td>MySQL</td><td></td><td>http://www.mysql.com/</td></tr>
  <tr><td>Strawberry Perl</td><td></td><td>http://strawberryperl.com/</td></tr>
</table>

Support
=======
Please use our Teamspeak 3 server for support. You may also post a request in the forums here http://opendayz.net/index.php?forums/support.100/  **NOTE** - teamspeak is the prefered method of support, you are more then welcome to stick around after your support issue has beeen handled. 

Teamspeak server: [teamspeak.hngamers.com](http://www.teamspeak.com/invite/teamspeak.hngamers.com)

