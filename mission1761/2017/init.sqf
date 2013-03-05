startLoadingScreen ["","DayZ_loadingScreen"];
enableSaving [false, false];

dayZ_hivePipe1 = 	"\\.\pipe\dayz";
dayZ_instance =	1;
hiveInUse	=	true;
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;

call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";
progressLoadingScreen 1.0;

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

if ((!isServer) && (isNull player) ) then {
	waitUntil {!isNull player};
	waitUntil {time > 3};
};

if ((!isServer) && (player != player)) then {
	waitUntil {player == player};
	waitUntil {time > 3};
};

if (isServer) then {
	hiveInUse	=	true;
	_serverMonitor = 	[] execVM "\z\addons\dayz_code\system\server_monitor.sqf";
};

if (isServer) then {
	[] execVM "scripts\zwoods.sqf";
};

if (!isDedicated) then {
	0 fadeSound 0;
	0 cutText [(localize "STR_AUTHENTICATING"), "BLACK FADED",60];
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = 	[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";	
};
