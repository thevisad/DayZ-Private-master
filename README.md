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



Реальность DayZ Private Server
=========================

Это частный проект сервера для DayZ, которые не были бы возможны без работы Rocket, Гуру и Абдул ayan4m1.
** NOTE **: Нет поддержки не подразумевается или предлагаются для пиратских копий ArmA 2.

Запрос поддержки
================

Мы переходим на поддержку сообщества для этого, пожалуйста, перейдите на следующий форум для запросов любую поддержку. http://opendayz.net/index.php?forums/support.100/


Реальность Builder Auto Updater
============================
Мы создали для обновления программного обеспечения. Это позволит пользователям получить последние поддерживаемого программного обеспечения из системы без необходимости проходить через GitHub. Данная программа обновления будет только загрузить последнюю стабильную версию программного обеспечения. Пользователи могут по-прежнему использовать GitHub, который будет иметь самой последней версии, но рекомендуется только для опытных пользователей и пользователей, которые будут делать тянуть запросов к системе. С Auto Updater можно гарантировать, что последняя поддерживаемая версия будет доступна для пользователя. инструменты

Скачать Реальность Builder Auto Updater здесь http://abighole.hngamers.com/10kli инструменты

После загрузки, запустите его и он будет установлен в C: \ RealityBuilder расположение файла. инструменты

Вопросы?
==========
Посетите Wiki https://github.com/thevisad/DayZ-Private-master/wiki/_pages


Схема базы данных 0,40 +
=====================
Начиная с схемы базы данных 0,40 + (Лингор Update) мы будем сброс части автомобиля таблиц. Сбросы часть пытается решить несколько вопросов со старыми схемами баз данных. Любые пользовательские добавлены транспортные средства должны быть перемещены до обновления в связи с рефакторинга vehilce чисел. Предполагается, что пользовательские транспортные средства присваивается номер выше, чем 1000, чтобы оставить место для любых и всех картах, которые будут добавлены в будущем.

Мы понимаем, что это может быть inconvienent для администраторов, которые сделали руки большую часть транспортных средств, однако мы считаем, что это будет лучше поддерживать всех пользователей этого программного обеспечения в долгосрочной перспективе и позволит карт, которые будут портированы быстрее Реальность системы.

Предпосылки
=============

 - Окна (проверено на 7 и Server 2008)
 - Рабочий ArmA 2 Комбинированный Ops выделенного сервера (Steam пользователи должны слиться ArmA2 и ArmA2 OA каталогов) с последней бета-патч установлен (http://www.arma2.com/beta-patch.php)
 - Microsoft Visual C + + 2010 SP1 x86 распространяемого (http://www.microsoft.com/en-us/download/details.aspx?id=8328)
 -. Microsoft NET Framework 4 или выше
 - Сервер MySQL 5.x с сети TCP / IP включен ** Примечание: ** Вы ** ** сусло использовать официальную установки MySQL, не XAMPP (http://dev.mysql.com/downloads/mysql/)
 - Десятичного разделителя на вашем сервере должен быть период. (Https://github.com/thevisad/DayZ-Private-master/wiki/Decimal-Separator)
 - Клубника Perl 32 Bit (не 64 бит)> = 5,16 (http://strawberryperl.com/) (64 бит не все зависимости правильной настройке)
 - DayZ 1.7.7.1 клиента (http://cdn.armafiles.info/latest/1.7.7.1/% 40Client-1.7.7.1-Full.rar)

Установка
============

** NOTE **: важность выполнения каждого из шагов в вики правильно и в целях не может быть занижена.
** Примечание **: Настоятельно рекомендуется отключить UAC при установке части, особенно, Perl части установки. Щелчок правой кнопкой мыши и работает как администрация ** не работает должным образом *** из-за способа, что Perl приложение настройки работает.

Обновление
========
 1. Выполнить update_scripts.pl. \ Util \ dayz_config \ BattlEye (при использовании BattlEye)
 2. Выполнить update_bans.pl - Dwarden - Banz - CBL -. Сохранить \ Util \ dayz_config \ BattlEye \ bans.txt (по желанию)
 3. Создайте свой мир, если вы делаете это в обратном направлении, то скрипты будут старые или вам нужно объединить их в вашу папку BattlEye вручную. Приведенный выше метод обеспечивает скрипты / запретов внутри сборки сервера перед копированием его в папку.


Дополнительные возможности
=================

Можно включить пользовательские пакеты при создании вашего файлах на сервере.
Список Reality-поддерживаемых пакетов следующим образом.

<table>
  <tr>
    <td> Имя </ TD> <td> Param </ TD> <td> Описание </ TD>
  </ TR>
  <tr>
    <td> carepkgs </ TD> <td> - с-carepkgs </ TD> <td> Капли медицинские наборы с различными типами добычи по карте (по аналогии с места аварии вертолета) </ TD>
  </ TR>
  <tr>
    <td> killmsgs </ TD> <td> - с-killmsgs </ TD> <td> Показывает в игре сообщения, когда один игрок убивает другого. Пользовательские фильтры BE должен использоваться (скачать находятся на рассмотрении) </ TD>
  </ TR>
  <tr>
    <td> сообщениями </ TD> <td> - с сообщениями </ TD> <td> замена для старых функций планировщика см. <b> сообщений / Scheduler </ B> ниже </ TD>
  </ TR>
  <tr>
    <td> зданий </ TD> <td> - с-зданий </ TD> <td> Разрешить нереста определенные базой данных структур / зданий на карте, см. <b> зданий </ B> </ TD>
  </ TR>
  <tr>
    <td> обломки </ TD> <td> - с затонувших кораблей-</ TD> <td> нерестится lootable различных обломков автомобиля по карте на сервере старт </ TD>
  </ TR>
  <tr>
    <td> invcust </ TD> <td> - с-invcust </ TD> <td> Позволяет предоставить пользовательские икру loadouts для отдельных лиц или группы см. <b> Пользовательские инвентаризации </ B> </ TD>
  </ TR>
  <tr>
    <td> mbg_celle2 </ TD> <td> - с-mbg_celle2 </ TD> <td> Сервер-ПБО изменения / исправления для Целле </ B> </ TD>
  </ TR>
  <tr>
    <td> ssZeds </ TD> <td> - с-ssZeds </ TD> <td> отключить серверные зомби моделирования (может улучшить сервер FPS) </ TD>
  </ TR>
  <tr>
    <td> ssZedsMessaging </ TD> <td> - с-ssZedsMessaging </ TD> <td> отключить серверные зомби моделирования (может улучшить сервер FPS) и сообщений пакетов все в одном лице. если вы хотите оба пакета, пожалуйста, используйте этот так нет слияния вопросов. </ TD>
  </ TR>
</ TABLE>



Благодаря
=========

Каждый из этих пакетов является частью реальности и делает то, что мы делаем возможным.

<table>
  <tr> <th> Имя </ TH> <th> Автор </ TH> <th> URL </ TH> </ TR>
  <tr> <td> cPBO </ TD> <td> Kegetys </ TD> <td> http://www.kegetsys.fi </ TD> </ TR>
  <tr> <td> GnuWin32 (Wget) </ TD> <td> </ TD> <td> http://gnuwin32.sourceforge.net </ TD> </ TR>
  <tr> <td> MySQL </ TD> <td> </ TD> <td> http://www.mysql.com/ </ TD> </ TR>
  <tr> <td> Strawberry Perl </ TD> <td> </ TD> <td> http://strawberryperl.com/ </ TD> </ TR>
</ TABLE>

Поддерживать
=======
Пожалуйста, используйте наш сервер TeamSpeak 3 для поддержки. Вы можете также разместить запрос на форумах здесь http://opendayz.net/index.php?forums/support.100/ ** NOTE ** - TeamSpeak является предпочтительным методом поддержки, у вас больше, то добро пожаловать, чтобы остаться после вашей поддержкой вопрос beeen обработаны.

Teamspeak сервер: [teamspeak.hngamers.com] (http://www.teamspeak.com/invite/teamspeak.hngamers.com)
