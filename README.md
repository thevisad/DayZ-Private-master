DayZ Bliss Private Server
=========================

This is a private server project for DayZ.
This code is currently compatible with DayZ 1.7.2.6 and ArmA 2 OA beta patch build 96584.

This would not be possible without the work of Rocket and Guru Abdul. We also use the fantastic cPBO from Kegetys (www.kegetys.fi) and wget for Windows by the GnuWin32 team (gnuwin32.sourceforge.net).

**NOTE**: No support is implied or offered for pirated copies of ArmA 2.

Prerequisites
=============

 - Windows (tested with 7 and Server 2008)
 - A working ArmA 2 Combined Ops dedicated server (Steam users must merge ArmA2 and ArmA2 OA directories) with recommended beta patch installed (http://www.arma2.com/beta-patch.php)
 - MySQL Server 5.x with TCP/IP Networking enabled **NOTE:** You **must** use the official MySQL installer, not XAMPP (http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.27-win32.msi/from/http://cdn.mysql.com)
 - The decimal separator on your server MUST BE a period. If it is a comma, vehicle spawning (at least) will not work correctly. **NOTE:** If you use FireDaemon to start your server, you must re-create the service if you change the comma separator in Windows.
 - A working Perl interpreter - Strawberry Perl is recommended (http://strawberryperl.com/)

Directories
===========

When you see the following names in bold, substitute in the appropriate path as described.

 - **ArmA2** - this is the root directory of your ArmA 2 installation
 - **Repository** - this is the directory you have extracted (or cloned) these private server files to

Installation
============

1. Download DayZ 1.7.2.6 and place the PBO files in **ArmA2**\\@DayZ\\Addons. 
2. Run `setup_perl.bat`. If you are prompted to provide a schema path, press enter to continue. If you are prompted Yes/No to run tests, type "n" and press Enter.  
3. Run `perl repack.pl` in **Repository**.  
4. Copy all files from **Repository**\\deploy into **ArmA2**\\  
5. Run the following SQL code as the **root** user (be **sure** to change the password from CHANGEME):  

		create database dayz;
		create user 'dayz'@'localhost' identified by 'CHANGEME';
		grant all privileges on dayz.* to 'dayz'@'localhost';

6. Run `perl db_migrate.pl --password CHANGEME`. Replace `CHANGEME` with the password you chose in the previous step. Use the `--help` flag to get more information on how to set the hostname, username, or database name to suit your needs.  
7. Ensure that the database information in **ArmA2**\\bliss.ini match the values you used in the previous step.  
8. Adjust server name/passwords in `ArmA2\\Bliss\\config_deadbeef.cfg`, (`BlissLingor` for Lingor Island) where `deadbeef` is some random value generated when running repack.pl.  
9. If you would like to customize the server time, run `perl db_settings.pl tzoffset <offset>`, replacing `<offset>` with an integer number of hours (positive or negative). Please note that the default instance ID is 1; if you use another instance ID, you will need to run `perl db_settings.pl --instance X tzoffset <offset>`, replacing `X` with your instance ID.  
10. If you would like to customize the starting loadout, run `perl db_settings.pl loadout <loadout>`, replacing `<loadout>` with a valid loadout string. Some examples:  
	- Default DayZ loadout - **[]**
	- Survival loadout - **[["ItemMap","ItemCompass","ItemMatchbox","FoodCanBakedBeans","ItemKnife","FoodCanBakedBeans"],["ItemTent","ItemBandage","ItemBandage"]]**
	- PvP loadout - **[["Mk_48_DZ","NVGoggles","Binocular_Vector","M9SD","ItemGPS","ItemToolbox","ItemEtool","ItemCompass","ItemMatchbox","FoodCanBakedBeans","ItemKnife","ItemMap","ItemWatch"],[["100Rnd_762x51_M240",47],"ItemPainkiller","ItemBandage","15Rnd_9x19_M9SD","100Rnd_762x51_M240","ItemBandage","ItemBandage","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","ItemMorphine","PartWoodPile"]]**
11. Run **ArmA2**\\server.bat to start the Chernarus server or **ArmA2**\\server_lingor.bat to start the Lingor server. **NOTE:** You cannot run Chernarus and Lingor using the same MySQL database.

Upgrading
=========

Depending on what has changed since you deployed your server, you may need to perform one or more steps to do a clean upgrade to the latest code. Look for the following in the commit log (specifically, the files that were changed) when you update to the latest version of the repository:

If you see that SQL files or db_migrate.pl have changed, then you **must** run `perl -w db_migrate.pl` (with appropriate options, run it with `--help` for more information) to upgrade your database to the latest version.
If SQF files (game script) has changed, then you **must** run repack.pl and copy the **Repository**\\deploy\\@Bliss directory into **ArmA 2** and overwrite dayz_server.pbo.
If configuration files and BattlEye anti-cheat files have changed, you will need to backup and overwrite your existing versions of these files. Take care to change any default server names, passwords or similar back to their customized values after copying the new versions into your **ArmA2** directory.

These are the areas you will need to inspect to ensure a smooth upgrade. If database and code changes were not made at the same time and you do not read the history thoroughly, you may miss important changes and skip vital steps. It will save you frustration in the long run if you repack and redeploy @Bliss, run `perl -w db_migrate.pl` and check for any new or changed files in **Repo**\\Deploy whenever you would like to update.

If you have a change that can make this process easier without adding bloat to the repository, the team would be happy to hear from you. Open an issue or see the Support section below.

Vehicles
========

Run `perl db_spawn_vehicles.pl` to get help information on how to invoke the vehicle spawn script correctly. You will need to run the vehicle script and point it to your database to get vehicles to spawn in-game. You **MUST** set the correct world when running db_spawn_vehicles.pl, if you leave the world unspecified the default is Chernarus which will not work correctly if you are running Lingor island. The script can be run periodically - it will not delete all vehicles every time it runs. It will clean up user-deployed objects (wire fence, tents, tank traps, etc) in the same way that official DayZ does. If you run db_spawn_vehicles.pl with the `--cleanup` argument, it will also check for out-of-bounds objects and delete them.

**NOTE:** Vehicles added/updated via database manipulation are only available after a server restart.

Multiple Instances
==================

You can run multiple server instances connected to the same database to provide a private cluster of servers all using the same player information. This can be done with Chernarus and Lingor Island, but you cannot mix players from one map with players from the other. If you did this, the characters positions would be wildly different and players would end up in the ocean or dead under the ground.

1. Determine what world you will be creating a new instance for. Duplicate either dayz_1.chernarus or dayz_1.lingor in **Repo**\\bliss\\missions. Rename it, replacing the "1" with the new instance ID you intend to use.  
2. Run `perl repack.pl` from the **Repo** directory.  
3. Copy all PBOs in **Repo**\\deploy\\MPMissions to **ArmA2**\\MPMissions.  
4. Duplicate the **ArmA2**\\Bliss (or BlissLingor) directory and server.bat (or server_lingor.bat). Rename them so it is clear what instance ID they are for.  
5. Edit the new server.bat so that it points to the new profile directory you created in step 4.  
6. Edit the config.cfg file in the profile directory created in step 4 so that the mission template refers to the new instance ID (e.g. change dayz_1.chernarus to dayz_2.chernarus).  
7. Edit **ArmA2**\\bliss.ini and add a new section for your instance. Change the section header so that it refers to the new instance ID and make sure the database configuration options are correct.
8. Run the new server.bat file you created in step 4.

Care must be taken to ensure that all paths and options have been set correctly. With this system you can run as many instances as your server can support simultaneously.

Customization
=============

Here are the most common customization requests with instructions.

**Request**: I would like to change the available chat channels.  
**Solution**: Go into **Repository**\\bliss\\missions\\dayz_1.chernarus (or .lingor for Lingor Island) and edit `description.ext`. Refer to http://community.bistudio.com/wiki/Description.ext#disableChannels for a mapping of channel names to numbers. Then run `repack.pl` and redeploy the files in **Repository**\\deploy\\MPMissions.

**Request**: I would like to change the server timezone.  
**Solution**: Run `perl db_settings.pl --instance X tzoffset <offset>`, replacing `X` with your instance ID (default is 1) and `<offset>` with an integer. This will set the positive or negative offset applied (in hours) to the system time, which is checked when the server starts up.

**Request**: I would like to have constant daylight (or moonlight) on my server.  
**Solution**: There is no easy solution for this. There is no way to halt the progression of time using SQF. If you *really* want to do this, you would have to modify the proc_getInstanceTime procedure to always return a constant time and then schedule automatic restarts such that before the sun sets (or rises) you are restarting/resetting the server back to the static starting time.

**Request**: I would like to alter difficulty options (3rd-person, crosshairs, name tags, etc).
**Solution**: Edit **ArmA2**\\Bliss\\Users\\Bliss\\Bliss.ArmA2OAProfile. An explanation of the options is available at http://community.bistudio.com/wiki/server.armaprofile. You must restart the server for these changes to take effect.

Scheduler
=========

By inserting rows into the scheduler table, you can set up custom messages displayed ingame over several chat channels. You can also make script calls. The mvisibility value you choose must be the same as the visibility field in the instances table for the messages to be displayed on that instance. The looptime and mstart fields should be given in seconds.

Mtype field:
<table>
  <tr>
    <td>Type</td><td>Name</td>
  </tr>
  <tr>
    <td>l</td><td>Local</td>
  </tr>
  <tr>
    <td>m</td><td>Side</td>
  </tr>
  <tr>
    <td>g</td><td>Global</td>
  </tr>
  <tr>
    <td>s</td><td>Script</td>
  </tr>
</table>

Whitelist
=========

Bliss is optionally capable of only allowing whitelisted players on your server. This feature is disabled by default. To enable it, do the following:

1. Using a MySQL administration utility, set the whitelist field to 1 for your instance (in the instances table).  
2. Set the is_whitelisted column to 1 for any row in the profile table that you would like to be whitelisted.  

A server restart is not required for whitelist changes to take effect. If you would like to whitelist players who have not logged in yet, you will need to insert a row into profile with is_whitelisted set to 1 before they connect. You can do this programmatically by running `perl db_settings.pl whitelist add <profile_id>`, replacing `<profile_id>` with a profile ID (also known as a UID but **not** a BE GUID). Alternatively, you can use this example query if you are building an application that has native SQL capability:

> insert into profile (unique_id, name, is_whitelisted) values ('12345678', 'DemoPlayer', 1);

The whitelist is completely independent of server password or any firewall you may be using to control access. Players who are not whitelisted will be stuck at "Loading" when they try to connect.

Gotchas / Known Bugs
==========

Character data can become desynchronized if the player was connected within several minutes of server shutdown. We strongly recommend that you wait 5 minutes after all players have disconnected before shutting down a public server.

Any bug present in the official client or server will probably also exist in this solution. Please do **not** report these as issues on GitHub. Some of the official bugs:
 - Loss of backpack due to bandit morphing or on respawn
 - Spawning in debug areas (plains / ocean)
 - Day / night cycle desync
 - Vehicle damage not persisting / vehicles repairing themselves

Common Issues
=============

**Problem**: Stuck at Loading / Wait for Host or Error Zero divisor in **arma2oaserver.rpt**  
**Solution**: Look in `blisshive.log` for MySQL connection errors (Google these to find troubleshooting steps). Ensure you have a valid MySQL user created, have run db_migrate.pl successfully, have set all options correctly in **ArmA2**\\bliss.ini and that you can run the following when logged in to MySQL:  

	call proc_getInstanceTime(1);

**Problem**: You get errors referring to `libmysql_.dll` or see errors indicating a missing `DBD/mysql.pm` or `DBD::mysql` when running db_migrate.pl or db_spawn_vehicles.pl.  
**Solution**: Use Strawberry Perl instead of ActivePerl. If that does not resolve the issue, try running `cpan DBD::mysql` in a command prompt or adding your Perl bin directory to the PATH environment variable.

**Problem**: Server crashes when the first player connects  
**Solution**: Ensure that you have blisshive.dll in your **ArmA2**\\@Bliss or **ArmA2**\\@BlissLingor directory and that you have a valid and well-formed **ArmA2**\\bliss.ini.

**Problem**: Kicked from the game when using non-DayZ weapons/vehicles  
**Solution**: Disable BattlEye by setting battleye=0 in **ArmA2**\\Bliss\\config.cfg, but note that this opens your server to hackers/griefers.

**Problem**: Server not listed on GameSpy in-game server list or third-party server lists 
**Solution**: Ensure the game ports (default 2302 - 2305 UDP) are forwarded properly and that the GameSpy master server is up and running.  

**Problem**: "Bad CD Key" messages  
**Solution**: Buy the game.


Support
=======

**IRC**: irc.thekreml.in #dayz
