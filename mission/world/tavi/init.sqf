startLoadingScreen ["","DayZ_loadingScreen"];
enableSaving [false, false];

dayZ_instance = 1;	//The instance
hiveInUse	=	true;
initialized = false;
dayz_previousID = 0;

call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf"; //Initilize the Variables (IMPORTANT: Must happen very early)

// (Taviana) Override some of the variables:
call compile preprocessFileLineNumbers "\kh\dayztaviana\init\variables.sqf";

progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";	//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf"; //Functions used by CLIENT for medical
progressLoadingScreen 0.4;

// (Taviana) Don't call the regular compile:
// call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf"; //Compile regular functions

// (Taviana) Instead, call a copy of the DayZ 1.7.4.4 compiles:
call compile preprocessFileLineNumbers "\kh\dayztaviana\init\compiles.sqf"; //Compile regular functions

progressLoadingScreen 1.0;

player setVariable ["BIS_noCoreConversations", true];
enableRadio false;

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

if (isServer) then {
	hiveInUse = true;
	_serverMonitor = [] execVM "\z\addons\dayz_server\system\server_monitor.sqf";
};

if (!isDedicated) then {
	0 fadeSound 0;
	0 cutText [(localize "STR_AUTHENTICATING"), "BLACK FADED",60];
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = 	[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";

};

// Extra actions for Taviana:
if (!isDedicated) then {
	[] execVM "kh_actions.sqf";
};

