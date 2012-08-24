DayZ Bliss Private Server
=========================

This is a private server project for DayZ.
This code is currently compatible with DayZ 1.7.2.5 and ArmA 2 OA beta patch build 95883.

This would not be possible without the work of Rocket and Guru Abdul. We also use the fantastic cPBO from Kegetys (www.kegetys.fi) and wget for Windows by the GnuWin32 team (gnuwin32.sourceforge.net).

**NOTE**: No support is implied or offered for pirated copies of ArmA 2.

Prerequisites
=============

 - Windows (tested with 7 and Server 2008)
 - A working ArmA 2 Combined Ops dedicated server with recommended beta patch installed (http://www.arma2.com/beta-patch.php)
 - MySQL Server 5.x with TCP/IP Networking enabled
 - Connector/Net 6.5.x (http://www.mysql.com/downloads/connector/net)
 - Microsoft Visual C++ 2010 Redistributable (http://www.microsoft.com/en-us/download/details.aspx?id=8328)
 - Microsoft .NET Framework 4 Client Profile (http://www.microsoft.com/download/en/details.aspx?id=24872)
 - The decimal separator on your server MUST BE a period. If it is a comma, vehicle spawning (at least) will not work correctly.
 - A working Perl interpreter - Strawberry Perl is recommended (http://strawberryperl.com/)

Directories
===========

When you see the following names in bold, substitute in the appropriate path as described.

 - **ArmA2** - this is the root directory of your ArmA 2 installation
 - **Repository** - this is the directory you have extracted (or cloned) these private server files to

Installation
============

1. Download DayZ 1.7.2.5 and place the PBO files in **ArmA2**\\@DayZ\\Addons.  
2. Enter **Repository** and run **repack.bat**.  
3. Copy all files from **Repository**\\deploy into **ArmA2**\\  
4. Run the following SQL code as the **root** user (be **sure** to change the password from CHANGEME):  

		create database dayz;
		create user 'dayz'@'localhost' identified by 'CHANGEME';
		grant all privileges on dayz.* to 'dayz'@'localhost';

4. Run `setup_perl.bat`. This will install necessary modules for you.  
5. Run `perl -w db_migrate.pl --password CHANGEME`. Replace `CHANGEME` with the password you chose in the previous step. Use the `--help` flag to get more information on how to use this utility.  
6. Ensure that the username and password in **ArmA2**\\databases.txt match the user created in the previous step.  
7. Adjust server name/passwords in **ArmA2**\\Bliss\\config.cfg  
8. Adjust the **timezone** field in the instances table for instance 1. This is an offset applied to the time on your server. Therefore, if your Windows clock says 5:00 PM / 17:00 and your timezone is set to -5, it will be noon on your server.  
9. Adjust the **loadout** field in the instances table for instance 1. Some options:  
	- Default DayZ loadout - **[]**
	- Survival loadout - **[["ItemMap","ItemCompass","ItemMatchbox","FoodCanBakedBeans","ItemKnife","FoodCanBakedBeans"],["ItemTent","ItemBandage","ItemBandage"]]**
	- PvP loadout - **[["Mk_48_DZ","NVGoggles","Binocular_Vector","M9SD","ItemGPS","ItemToolbox","ItemEtool","ItemCompass","ItemMatchbox","FoodCanBakedBeans","ItemKnife","ItemMap","ItemWatch"],[["100Rnd_762x51_M240",47],"ItemPainkiller","ItemBandage","15Rnd_9x19_M9SD","100Rnd_762x51_M240","ItemBandage","ItemBandage","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","ItemMorphine","PartWoodPile"]]**
10. Run **ArmA2**\\server.bat to start the server.

Upgrading
=========

Depending on what has changed since you deployed your server, you may need to perform one or more steps to do a clean upgrade to the latest code. Look for the following in the commit log (specifically, the files that were changed) when you update to the latest version of the repository:
If you see that SQL files or db_migrate.pl have changed, then you **must** run `perl -w db_migrate.pl` (with appropriate options, run it with `--help` for more information) to upgrade your database to the latest version.  
If SQF files (game script) has changed, then you **must** run repack.bat and copy the **Repo**\\deploy\\@Bliss directory into **ArmA 2** and overwrite dayz_server.pbo.  
If configuration files and BattlEye anti-cheat files have changed, you will need to backup and overwrite your existing versions of these files. Take care to change any default server names, passwords or similar back to their customized values after copying the new versions into your **ArmA2** directory.

These are the areas you will need to inspect to ensure a smooth upgrade. If database and code changes were not made at the same time and you do not read the history thoroughly, you may miss important changes and skip vital steps. It will save you frustration in the long run if you repack and redeploy @Bliss, run `perl -w db_migrate.pl` and check for any new or changed files in **Repo**\\Deploy whenever you would like to update.

If you have a change that can make this process easier without adding bloat to the repository, the team would be happy to hear from you. Open an issue or see the Support section below.

Vehicles
========

Run `perl vehicles.pl` to get help information on how to invoke the vehicle spawn script correctly. You will need to run the vehicle script and point it to your database to get vehicles to spawn in-game. You **MUST** set the correct world when running vehicles.pl, if you leave the world unspecified the default is Chernarus which will not work correctly if you are running Lingor island. The script can be run periodically - it will not delete all vehicles every time it runs. It will clean up user-deployed objects (wire fence, tents, tank traps, etc) in the same way that official DayZ does. If you run vehicles.pl with the `--cleanup` argument, it will also check for out-of-bounds objects and delete them.

**NOTE:** Vehicles added via database manipulation are only available after a server restart.

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

Gotchas / Known Bugs
==========

Character data can become desynchronized if the player was connected within several minutes of server shutdown. We strongly recommend that you wait 5 minutes after all players have disconnected before shutting down a public server.

Any bug present in the official client or server will probably also exist in this solution. Please do **not** report these as issues on GitHub. Some of the official bugs:
 - Texture issues / graphical corruption / artifacts
 - Loss of backpack on model change (due to bandit morphing) or on respawn
 - Spawning in debug plains or in the ocean

Common Issues
=============

**Problem**: You get errors referring to MSVCR100.dll when the first player connects  
**Solution**: Install MSVC++ 2010 Redist (see Prerequisites for URL)

**Problem**: Server crashes when the first player connects  
**Solution**: Ensure that the DLL files in **ArmA2**\\@Arma2NET are not "blocked" by Windows by right-clicking on them and selecting **Properties**. If you see an Unblock button, click it and do the same for all DLLs in this directory.

**Problem**: Kicked from the game when using non-DayZ weapons/vehicles  
**Solution**: Disable BattlEye by setting battleye=0 in **ArmA2**\\Bliss\\config.cfg, but note that this opens your server to hackers/griefers.

**Problem**: Server not listed on GameSpy in-game server list  
**Solution**: Change reportingIP to **arma2oapc.master.gamespy.com** and ensure the game ports (default 2302 - 2305 UDP) are forwarded properly.

**Problem**: "Bad CD Key" messages  
**Solution**: Buy the game.

**Problem**: Error Zero divisor in **arma2oaserver.rpt**  
**Solution**: Ensure you have a MySQL user called **'dayz'@'localhost'** and that you can run the following when logged in to MySQL as that user:  

	use dayz;
	call getTime(1);

If that procedure does not exist, use a tool other than MySQL Workbench to import the database.

Support
=======

**IRC**: irc.thekreml.in #dayz
