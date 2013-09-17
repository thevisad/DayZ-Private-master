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

dzn_ns_bloodsucker = true;		// Make this false for disabling bloodsucker spawn
dzn_ns_bloodsucker_den = 70;	// Spawn chance of bloodsuckers, max 400, ignore if dzn_ns_bloodsucker set to false
ns_blowout = true;			// Make this false for disabling random EVR discharges (blowout module)
ns_blowout_dayz = true;		// Leave this always true or it will create a very huuuge mess
ns_blow_delaymod = 1;		// Multiplier of times between each EVR dischargers, 1x value default (normal pre-0.74 times)
dayzNam_buildingLoot = "CfgBuildingLootNamalsk";	// can be CfgBuildingLootNamalskNOER7 (function of this pretty obvious), CfgBuildingLootNamalskNO50s (CfgBuildingLootNamalskNOER7 + no 50 cals), CfgBuildingLootNamalskNOSniper (CfgBuildingLootNamalskNOER7 + no sniper rifles), default is CfgBuildingLootNamalsk

call compile preprocessFileLineNumbers "\nst\ns_dayz\code\init\variables.sqf"; //Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";	//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf"; //Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "\nst\ns_dayz\code\init\compiles.sqf"; //Compile regular functions
progressLoadingScreen 1.0;

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

/* BIS_Effects_* fixes from Dwarden */
BIS_Effects_EH_Killed = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\killed.sqf";
BIS_Effects_AirDestruction = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\AirDestruction.sqf";
BIS_Effects_AirDestructionStage2 = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\AirDestructionStage2.sqf";

BIS_Effects_globalEvent = {
	BIS_effects_gepv = _this;
	publicVariable "BIS_effects_gepv";
	_this call BIS_Effects_startEvent;
};

BIS_Effects_startEvent = {
	switch (_this select 0) do {
		case "AirDestruction": {
				[_this select 1] spawn BIS_Effects_AirDestruction;
		};
		case "AirDestructionStage2": {
				[_this select 1, _this select 2, _this select 3] spawn BIS_Effects_AirDestructionStage2;
		};
		case "Burn": {
				[_this select 1, _this select 2, _this select 3, false, true] spawn BIS_Effects_Burn;
		};
	};
};

"BIS_effects_gepv" addPublicVariableEventHandler {
	(_this select 1) call BIS_Effects_startEvent;
};

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
		waitUntil {!isNil "dayz_loadScreenMsg"};
		dayz_loadScreenMsg = (localize "STR_AUTHENTICATING");
		
		_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
		_playerMonitor =  [] execVM "\nst\ns_dayz\code\system\player_monitor.sqf";
	} else {
		endLoadingScreen;
		0 fadeSound 0;
		0 cutText ["You are running an incorrect version of DayZ: Namalsk, please download newest version from http://www.nightstalkers.cz/", "BLACK"];
	};
};

// Logo watermark: adding a logo in the bottom left corner of the screen with the server name in it
if (!isNil "dayZ_serverName") then {
	[] spawn {
		waitUntil {(!isNull Player) and (alive Player) and (player == player)};
		waituntil {!(isNull (findDisplay 46))};
		5 cutRsc ["wm_disp","PLAIN"];
		((uiNamespace getVariable "wm_disp") displayCtrl 1) ctrlSetText dayZ_serverName;
	};
};
