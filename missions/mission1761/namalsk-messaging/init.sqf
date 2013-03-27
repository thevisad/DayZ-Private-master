/*	
	INITILIZATION
*/
startLoadingScreen ["","RscDisplayLoadCustom"];
cutText ["","BLACK OUT"];
enableSaving [false, false];

//REALLY IMPORTANT VALUES
dayZ_instance = 1;					//The instance
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;

dzn_ns_bloodsucker = true;		// Make this falso for disabling bloodsucker spawn
dzn_ns_bloodsucker_den = 40;	// Spawn chance of bloodsuckers, max 100 (100 == 0.72 version status == 100% spawn), ignore if dzn_ns_bloodsucker set to false
ns_blowout = true;			// Make this false for disabling random EVR discharges (blowout module)
ns_blowout_dayz = true;		// Leave this always true or it will create a very huuuge mess
ns_blow_delaymod = 1;		// Multiplier of times between each EVR dischargers, 1x value default (normal pre-0.74 times)
dayzNam_buildingLoot = "CfgBuildingLootNamalsk";	// can be CfgBuildingLootNamalskNOER7 (function of this pretty obvious), CfgBuildingLootNamalskNOSniper (CfgBuildingLootNamalskNOER7 + no sniper rifles), default is CfgBuildingLootNamalsk

call compile preprocessFileLineNumbers "\nst\ns_dayz\code\init\variables.sqf"; //Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";	//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf"; //Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "\nst\ns_dayz\code\init\compiles.sqf"; //Compile regular functions
progressLoadingScreen 1.0;

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

if ((!isServer) && (isNull player) ) then
{
waitUntil {!isNull player};
waitUntil {time > 3};
};

if ((!isServer) && (player != player)) then
{
  waitUntil {player == player};
  waitUntil {time > 3};
};

if (isServer) then {
	_serverMonitor = 	[] execVM "\z\addons\dayz_code\system\server_monitor.sqf";
};

if (!isDedicated) then {
 if (isClass (configFile >> "CfgBuildingLootNamalsk")) then {
  0 fadeSound 0;
  0 cutText [(localize "STR_AUTHENTICATING"), "BLACK FADED",60];
  _id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
  _playerMonitor =  [] execVM "\nst\ns_dayz\code\system\player_monitor.sqf";
 } else {
 endLoadingScreen;
 0 fadeSound 0;
 0 cutText ["You are running an incorrect version of DayZ: Namalsk, please download newest version from http://www.nightstalkers.cz/", "BLACK"];
 };
};