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

Directories
===========

When you see the following names in bold, substitute in the appropriate path as described.

 - **ArmA2** - this is the root directory of your ArmA 2 installation
 - **Repository** - this is the directory you have extracted (or cloned) these private server files to

Installation
============

1. Download DayZ 1.7.2.5 and place the PBO files in **Repository**\\@DayZ\\Addons.
2. Enter **Repository** and run **repack.bat**.
3. Copy all files from **Repository**\\deploy into **ArmA2**\\
4. Run **Repository**\\dayz2_0.sql on your MySQL server as the **root** user. Do **NOT** use MySQL Workbench to run the SQL queries, it will not work. I recommend "TOAD for MySQL," but every user will have their own preference.
5. Run **Repository**\\2_0to2_1.sql on your MySQL server as the **root** user.
6. Run **Repository**\\2_1to2_2.sql on your MySQL server as the **root** user.
6. Run the following SQL code as the **root** user (be **sure** to change the password from CHANGEME):  

		create user 'dayz'@'localhost' identified by 'CHANGEME';  
		grant all privileges on dayz.* to 'dayz'@'localhost';

7. Ensure that the username and password in **ArmA2**\\databases.txt match the user created in the previous step.
8. Adjust server name/passwords in **ArmA2**\\Bliss\\config.cfg
9. Adjust the **timezone** field in the instances table for instance 1. This is an offset applied to the time on your server. Therefore, if your Windows clock says 5:00 PM / 17:00 and your timezone is set to -5, it will be noon on your server. 
10. Adjust the **loadout** field in the instances table for instance 1. Some options:
	- Default DayZ loadout - **[]**
	- Survival loadout - **[["ItemMap","ItemCompass","ItemMatchbox","FoodCanBakedBeans","ItemKnife","FoodCanBakedBeans"],["ItemTent","ItemBandage","ItemBandage"]]**
	- PvP loadout - **[["Mk_48_DZ","NVGoggles","Binocular_Vector","M9SD","ItemGPS","ItemToolbox","ItemEtool","ItemCompass","ItemMatchbox","FoodCanBakedBeans","ItemKnife","ItemMap","ItemWatch"],[["100Rnd_762x51_M240",47],"ItemPainkiller","ItemBandage","15Rnd_9x19_M9SD","100Rnd_762x51_M240","ItemBandage","ItemBandage","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","ItemMorphine","PartWoodPile"]]**
11. Run **ArmA2**\\server.bat to start the server.

Vehicles
========

To add vehicles, you will need a working Perl installation. Strawberry Perl (http://strawberryperl.com) is a Windows Perl environment with a simple installer.
Once you have access to Perl from the command-line, run "perl vehicles.pl" to get help information on how to invoke the script.

Vehicles added via database manipulation are only available after a server restart.

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

All vehicles and tents must be saved using the "Save <Object>" scroll menu item, especially if preparing for a server shutdown.

Some tents will not be removed from the database when they are repacked. This means that a "duplicate" tent will be created and on server restart the repacked tent will appear once again.

Any bug present in the official client or server will probably also exist in this solution. This includes:

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
