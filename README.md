DayZ Reality Private Server
=========================

This is a private server project for DayZ which would not be possible without the work of Rocket, Guru Abdul and ayan4m1.   
**NOTE**: No support is implied or offered for pirated copies of ArmA 2.

Support Requests
================

We are moving to community support for this, Please go to the following forum for any and all support requests. http://opendayz.net/index.php?forums/support.100/


Reality Builder Auto Updater
============================
We have created an updater for the software. This will allow the users to get the latest supported software from the system without having to go through github. This updater will only download the most current stable version available. Users may still use the github which will have the absolute latest version, but is only recommended for advanced users and users who will be doing pull requests to the system. With the auto updater you can ensure that the latest supported version will be available for your user. <br>

Download the Reality Builder Auto updater here http://abighole.hngamers.com/10kli <br>

After download, run it and it will install to the c:\RealityBuilder file location. <br>

Questions?
==========
Visit the Wiki https://github.com/thevisad/DayZ-Private-master/wiki/_pages


Database Schema 0.40+
=====================
Starting with database schema 0.40+ (Lingor Update) we will be reseting portions of the vehicle tables. The resets are part of trying to resolve multiple issues with the old database schemas. Any custom added vehicles will need to be moved prior to update due to the refactoring of the vehilce numbers. It is suggested that custom vehicles be given a number higher then 1000 to leave room for any and all maps that will be added in the future. 

We understand that this may be inconvienent for admins who have hand done large portions of vehicles; however, we feel that this will better support all users of this software in the long run and allow maps to be ported faster to the Reality system. 

Prerequisites
=============

 - Windows (tested with 7 and Server 2008)
 - A working ArmA 2 Combined Ops dedicated server (Steam users must merge ArmA2 and ArmA2 OA directories) with the latest beta patch installed (http://www.arma2.com/beta-patch.php)
 - Microsoft Visual C++ 2010 SP1 x86 Redistributable (http://www.microsoft.com/en-us/download/details.aspx?id=8328)
 - Microsoft .NET Framework 4 or higher
 - MySQL Server 5.x with TCP/IP Networking enabled **NOTE:** You **must** use the official MySQL installer, not XAMPP (http://dev.mysql.com/downloads/mysql/)
 - The decimal separator on your server MUST BE a period. (https://github.com/thevisad/DayZ-Private-master/wiki/Decimal-Separator)
 - Strawberry Perl 32 Bit (NOT 64 Bit)>= 5.16 (http://strawberryperl.com/) (64 bit does not have all the dependencies properly setup)
 - DayZ 1.7.7.1 client (http://cdn.armafiles.info/latest/1.7.7.1/%40Client-1.7.7.1-Full.rar) 

Installation
============

**NOTE**: The importance of following each of the steps in the wiki correctly and in order cannot be understated. 
**NOTE**: It is highly recommended to disable UAC during the install portion; especially, the perl setup portion. Right clicking and running as Administration **DOES NOT WORK PROPERLY*** due to the way that the Perl setup application works. 

Updating
========
 1. Run update_scripts.pl .\util\dayz_config\BattlEye (if using Battleye)
 2. Run update_bans.pl --dwarden --banz --cbl --save .\util\dayz_config\BattlEye\bans.txt (if desired)
 3. Build your world, if you do this in reverse then the scripts will be old or you will need to merge them into your Battleye folder manually. The above method provides the scripts/bans inside of the server build prior to copying it to your folder. 


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
    <td>killmsgs</td><td>--with-killmsgs</td><td>Shows in-game messages when one player kills another. Custom BE filters must be used (Download Pending)</td>
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



Thanks To
=========

Each of these packages is a part of Reality and makes what we do possible.

<table>
  <tr><th>Name</th><th>Author</th><th>URL</th></tr>
  <tr><td>cPBO</td><td>Kegetys</td><td>http://www.kegetsys.fi</td></tr>
  <tr><td>GnuWin32 (wget)</td><td></td><td>http://gnuwin32.sourceforge.net</td></tr>
  <tr><td>MySQL</td><td></td><td>http://www.mysql.com/</td></tr>
  <tr><td>Strawberry Perl</td><td></td><td>http://strawberryperl.com/</td></tr>
</table>

Support
=======
Please use our Teamspeak 3 server for support. You may also post a request in the forums here http://opendayz.net/index.php?forums/support.100/  **NOTE** - teamspeak is the prefered method of support, you are more then welcome to stick around after your support issue has beeen handled. 

Teamspeak server: [teamspeak.hngamers.com](http://www.teamspeak.com/invite/teamspeak.hngamers.com)

