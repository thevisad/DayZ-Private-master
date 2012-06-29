/*
*	Original by Rocket (www.dayzmod.com)
*	Private persistance by Guru Abdul.
*	Enjoy the custom character server!
*/
enableSaving [false, false];
if !(isClass (configFile >> "CfgMods" >> "DayZ")) exitWith {hintc "DayZ mod must be installed and activated, for this mission to run!";};
_dzv = parseNumber (getText (configFile >> "CfgMods" >> "DayZ" >> "version"));
dayz_instance = 1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";				
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";				
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";	
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";
dayz_preloadFinished = true;		
if (isServer) then {
	[] execVM "server\server_monitor.sqf";
};
if (!isDedicated) then {
	0 fadeSound 0;
	0 cutText [(localize "STR_AUTHENTICATING"), "BLACK FADED",60];
	player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	[] execFSM "\z\addons\dayz_code\system\player_monitor.fsm";
};
