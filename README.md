DayZ Bliss Private Server
=========================

This is a private server project for DayZ which would not be possible without the work of Rocket and Guru Abdul.   
**NOTE**: No support is implied or offered for pirated copies of ArmA 2.

**NOTE**: Do **NOT** create GitHub issues for support requests. They are **ONLY** to be created if you have a repeatable bug that you can provide copious debugging information about. See the end of the README for ways to get support.

Prerequisites
=============

 - Windows (tested with 7 and Server 2008)
 - A working ArmA 2 Combined Ops dedicated server (Steam users must merge ArmA2 and ArmA2 OA directories) with beta patch **99113** installed (http://www.arma2.com/beta-patch.php)
 - Microsoft Visual C++ 2010 SP1 x86 Redistributable (http://www.microsoft.com/en-us/download/details.aspx?id=8328)
 - MySQL Server 5.x with TCP/IP Networking enabled **NOTE:** You **must** use the official MySQL installer, not XAMPP (http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.27-win32.msi/from/http://cdn.mysql.com)
 - The decimal separator on your server MUST BE a period. If it is a comma, vehicle spawning (at least) will not work correctly. **NOTE:** If you use FireDaemon to start your server, you must re-create the service if you change the comma separator in Windows.
 - Strawberry Perl >= 5.16 (http://strawberryperl.com/)

Directories
===========

**IMPORTANT**: When you see the following names in bold, substitute in the appropriate path as described.

 - **ArmA2** - this is the root directory of your ArmA 2 installation.
 - **Repository** - this is the directory you have extracted (or cloned) these private server files to.
 - **Config** - this is a directory called `dayz_<id>.<world>` created during deployment. Replace `<id>` with the instance ID and `<world>` with the world you specified when running build.pl.

Installation
============

**NOTE**: The importance of following each of these steps correctly and in order cannot be understated. 

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
8. Adjust server name/passwords as desired in **Config**\\config_deadbeef.cfg, where `deadbeef` is some random value generated specifically for your installation.  
9. If you would like to customize the starting loadout, run `perl db_utility.pl loadout <inventory> <backpack>`, replacing `<inventory>` with a valid inventory string and `<backpack>` with a valid backpack string. Some examples:  
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
    <td>World</td><td>World Name (Database)</td><td>Mod Folders</td><td>Version</td><td>URL</td>
  </tr>
  <tr>
    <td>Chernarus</td><td>chernarus</td><td>@dayz</td><td>1.7.4.4</td><td>http://dayzmod.com/?Download</td>
  </tr>
  <tr>
    <td>Lingor Island</td><td>lingor</td><td>@dayzlingor</td><td>1.2</td><td>ftp://dayzcommander:dayzcommander@94.242.227.3/DayZLingor-1.2.rar</td>
  </tr>
  <tr>
    <td>Takistan</td><td>takistan</td><td>@dayztakistan</td><td>1.6</td><td>ftp://dayzcommander:dayzcommander@94.242.227.3/DayZTakistan-1.6.rar</td>
  </tr>
  <tr>
    <td>Utes</td><td>utes</td><td>@dayz</td><td>1.7.4.4</td><td>http://dayzmod.com/?Download</td>
  </tr>
  <tr>
    <td>Panthera</td><td>panthera2</th><td>@dayzpanthera</td><td>1.7</td><td>ftp://dayzcommander:dayzcommander@94.242.227.3/DayZPanthera-1.7.rar</td>
  </tr>
  <tr>
    <td>Fallujah</td><td>fallujah</td><td>@dayzfallujah</td><td>1.4</td><td>ftp://dayzcommander:dayzcommander@94.242.227.3/DayZFallujah-1.4.rar</td>
  </tr>
  <tr>
    <td>Zargabad</td><td>zargabad</td><td>@dayzzargabad</td><td>1.4</td><td>ftp://dayzcommander:dayzcommander@94.242.227.3/DayZZargabad-1.4.rar</td>
  </tr>
  <tr>
    <td>Namalsk Island</td><td>namalsk</td><td>@dayz;@dayz_namalsk</td><td>0.60</td><td>ftp://dayzcommander:dayzcommander@94.242.227.3/DayZNamalsk-0.60.rar</td>
  </tr>
  <tr>
    <td>Celle</td><td>mbg_celle</td><td>@mbg_celle;@dayz_celle</td><td>1.7.4.4</td><td>http://cdn.dayz.st/dayzcommander/DayZCelle-1.7.4.4.rar</td>
  </tr>
  <tr>
    <td>Taviana</td><td>tavi</td><td>@taviana</td><td>1.7.4.4</td><td>http://cdn.dayz.st/dayzcommander/Taviana-1.7.4.4.rar</td>
  </tr>
</table>
11. If you are using a world other than Chernarus, run `perl db_utility.pl setworld <world_name>`, where `<world_name>` is the name of the world you specified when running `build.pl`.
12. Run **ArmA2**\\Restarter.exe to start the server.  

Upgrading
=========

**EXTREMELY IMPORTANT:** If you are migrating from **ANY** previous version of Bliss you will lose vehicles during the upgrade to schema 0.27.

Depending on what has changed since you deployed your server, you may need to perform one or more steps to do a clean upgrade to the latest code. Look for the following in the commit log (specifically, the files that were changed) when you update to the latest version of the repository:

If you see that SQL files or `db_migrate.pl` have changed, then you **must** run `db_migrate.pl` (with appropriate options, run it with `--help` for more information) to upgrade your database to the latest version.
If SQF files (game script) has changed, then you **must** run `build.pl` and copy the `**Repository**\\deploy\\@bliss_<id>.<world>\\` directory into **ArmA2**\\ (where `<id>` and `<world>` are the values you specified when running build.pl).
If configuration files and BattlEye anti-cheat files have changed in **Repository**\\deploy\\, you will need to backup and overwrite your existing versions of these files. Take care to change any default server names, passwords or similar back to their customized values after copying the new versions into your **ArmA2** directory.
If you receive an error like `Cannot locate Some::Module.pm in @INC` when running a Perl script after an upgrade, run `setup_perl.bat` and then try the Perl script again.

These are the areas you will need to inspect to ensure a smooth upgrade. If database and code changes were not made at the same time and you do not read the history thoroughly, you may miss important changes and skip vital steps. It will save you frustration in the long run if you rebuild and redeploy, run `db_migrate.pl` and check for any new or changed files in **Repository**\\deploy\\ whenever you would like to update.

Vehicles
========

Run `perl db_spawn_vehicles.pl --help` to get help information on how to invoke the vehicle spawn script correctly. You will need to run the vehicle script and point it to your database to get vehicles to spawn in-game. The script can be run periodically - it will not delete all vehicles every time it runs. It will clean up user-deployed objects (wire fence, tents, tank traps, etc) in the same way that official DayZ does. If you run db_spawn_vehicles.pl with the `--cleanup bounds` argument, it will also check for out-of-bounds objects and delete them.

**NOTE:** Vehicles added/updated via database manipulation are only available after a server restart.

Optional Features
=================

When running `build.pl`, you may specify additional options to merge in optional features. To get a list of optional features, run `perl build.pl --list`.

To install new optional features, use the `package_manager.pl` script. Run `perl package_manager.pl install <package-name>`, replacing `<package-name>` with the name of a package. You may browse packages at http://www.blissrepo.com. 

A list of Bliss-supported packages follows.

<table>
  <tr>
    <td>Name</td><td>Param</td><td>Description</td>
  </tr>
  <tr>
    <td>carepkgs</td><td>--with-carepkgs</td><td>Drops care packages with various loot types across the map (similar to heli crash sites)</td>
  </tr>
  <tr>
    <td>killmsgs</td><td>--with-killmsgs</td><td>Shows in-game messages when one player kills another (not needed for Lingor). Custom BE filters must be used (https://code.google.com/p/bliss-community-filters/downloads/list)</td>
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
</table> 

Multiple Instances
==================

You can run multiple server instances connected to the same database to provide a private cluster of servers all using the same character information.
 
1. Run `perl build.pl --world WORLD --instance ID` from the **Repository** directory, replacing WORLD with a valid world name and ID with a valid instance ID (the default is 1, so 2 would be sensible for a second instance).  
2. Copy all new directories and files from **Repository**\\deploy\\ to **ArmA2**\\.  
3. Edit **Config**\\HiveExt.ini and set the database / time zone parameters appropriately.
4. Insert a row into the instance table that has the instance ID you used previously and the correct world_id and starting loadout.  
5. Stop and start Restarter.exe for your new instance to start up.

Care must be taken to ensure that all paths and options have been set correctly. With this system you can run as many instances as your server can support simultaneously.

Messaging / Scheduler
=====================

You may optionally enable an in-game announcement system for Bliss. To do so, follow these steps:

1. Run `perl db_migrate.pl --schema BlissMessaging --version 0.01`. Be sure to include any parameters needed for your specific database passwords / configuration.  
2. When building Bliss, you must add `--with-messaging` to your arguments, for example `perl build.pl --with-messaging`.  
3. Use `perl db_utility.pl --help` to learn how to use the `messages` command to manage your messages without any direct database interaction.  

**NOTE:** Messages added/updated via database manipulation are only available after a server restart.

Buildings
=========

You may optionally enable a system that reads structure information from the database and spawns a set of static structures on the map on each server start. To do so, follow these steps:

1. Run `perl db_migrate.pl --schema BlissBuildings --version 0.01`. Be sure to include any parameters needed for your specific database passwords / configuration.  
2. When building Bliss, you must add `--with-buildings` to your arguments, for example `perl build.pl --with-buildings`.  
3. You must manually insert any building class names you wish to use into the building table and then insert the spawn coordinates / associated building IDs into the instance_building table.  

**NOTE:** Buildings added/updated via database manipulation are only available after a server restart.

Custom Inventory
================

You may optionally enable a system that allows you to define custom spawn loadouts for individuals and/or group. To do so, follow these steps:

1. Run `perl db_migrate.pl --schema BlissInvCust --version 0.02`. Be sure to include any parameters needed for your specific database passwords / configuration.  
2. When building Bliss, you must add `--with-invcust` to your arguments, for example `perl build.pl --with-invcust`.  

There are two tables which you must insert values into to use this feature. The `cust_loadout` table defines unique sets of inventory/backpack to give the player(s) on spawn. The `cust_loadout_profile` table then ties these cust_loadout rows to player profile IDs. You can associate multiple profile IDs to a single loadout with this relationship.

Customization
=============

Here are the most common customization requests with instructions.

**Request**: I would like to change the available chat channels.  
**Solution**: When running `build.pl`, add the `--channels <channel>` option, where `<channel>` is a comma-separated list of chat channel numbers, which will be **DISABLED**. Refer to http://community.bistudio.com/wiki/Description.ext#disableChannels for a mapping of channel names to numbers.

**Request**: I would like to alter difficulty options (3rd-person, crosshairs, name tags, etc).  
**Solution**: Edit **Config**\\Users\\Bliss\\Bliss.ArmA2OAProfile. An explanation of the options is available at http://community.bistudio.com/wiki/server.armaprofile. You must restart the server for these changes to take effect.

Gotchas / Known Bugs
==========

Character data can become desynchronized if the player was connected within several minutes of server shutdown. A heavily loaded server will continue processing backlogged player syncs for some time even after all players have been disconnected. We strongly recommend that you wait 5 minutes after all players have disconnected before shutting down a public server.

Any bug present in the official client or server will probably also exist in this solution. Please do **not** report these as issues on GitHub.

Common Issues
=============

**Problem**: You get errors referring to `libmysql_.dll` or see errors indicating a missing `DBD/mysql.pm` or `DBD::mysql` when running db_migrate.pl or db_spawn_vehicles.pl.  
**Solution**: Use Strawberry Perl instead of ActivePerl. If that does not resolve the issue, try running `cpan DBD::mysql` in a command prompt or adding your Perl bin directory to the PATH environment variable.

**Problem**: You get an error like `Cannot locate Some::Module.pm in @INC` when running a Perl script.  
**Solution**: Run `setup_perl.bat` and try to execute the Perl script again.

**Problem**: "Error Connecting to Service" / Stuck at Loading / Errors in **arma2oaserver.rpt**  
**Solution**: Look in **Config**\\hiveext.log for MySQL connection errors (Google these to find troubleshooting steps). If you do not have a **Config**\\hiveext.log file, right-click on `HiveExt.dll` in `@Bliss` (`@BlissLingor` for Lingor servers) and select Properties. If you see an Unblock button, click it and hit OK. Ensure you have a valid MySQL user created, have run db_migrate.pl successfully, have set all options correctly in **Config**\\HiveExt.ini and that you can run the following when logged in to MySQL:  

	select * from survivor;

**Problem**: Server crashes when the first player connects  
**Solution**: Ensure that you have `HiveEXT.dll` in your **ArmA2**\\@bliss_\<instance\>.\<world\> directory and that you have a valid and well-formed **Config**\\HiveExt.ini. Also ensure that you have tried both `localhost` and `127.0.0.1` as the hostname if you run MySQL on the same server as Bliss.

**Problem**: Server not listed on GameSpy in-game server list or third-party server lists  
**Solution**: Ensure the game ports (default 2302 - 2305 UDP) are forwarded properly and that the GameSpy master server is up and running.  

**Problem**: "Bad CD Key" messages  
**Solution**: Buy the game.

Thanks To
=========

Each of these packages is a part of Bliss and makes what we do possible.

<table>
  <tr><th>Name</th><th>Author</th><th>URL</th></tr>
  <tr><td>cPBO</td><td>Kegetys</td><td>http://www.kegetsys.fi</td></tr>
  <tr><td>GnuWin32 (wget)</td><td></td><td>http://gnuwin32.sourceforge.net</td></tr>
  <tr><td>MySQL</td><td></td><td>http://www.mysql.com/</td></tr>
  <tr><td>Strawberry Perl</td><td></td><td>http://strawberryperl.com/</td></tr>
</table>

Support
=======

**IRC**: irc.thekreml.in #bliss (Web chat interface at http://www.dayzprivate.com:55448)
