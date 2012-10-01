startLoadingScreen ["","DayZ_loadingScreen"];
enableSaving [false, false];

dayZ_instance = 1;	//The instance
hiveInUse	=	true;
initialized = false;
dayz_previousID = 0;
dayz_hiveVersionNo = 1;

call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";				//Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";				//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";	//Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";				//Compile regular functions
progressLoadingScreen 1.0;

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

// Vehicle damage fix
vehicle_handleDamage    = compile preprocessFileLineNumbers "fixes\vehicle_handleDamage.sqf";
vehicle_handleKilled    = compile preprocessFileLineNumbers "fixes\vehicle_handleKilled.sqf";

// Right-click error fix
player_selectSlot       = compile preprocessFileLineNumbers "fixes\ui_selectSlot.sqf";

// Player action hooks
player_build            = compile preprocessFileLineNumbers "fixes\player_build.sqf";
player_cook             = compile preprocessFileLineNumbers "fixes\player_cook.sqf";
player_drink            = compile preprocessFileLineNumbers "fixes\player_drink.sqf";
player_eat              = compile preprocessFileLineNumbers "fixes\player_eat.sqf";
player_useMeds          = compile preprocessFileLineNumbers "fixes\player_useMeds.sqf";
player_wearClothes      = compile preprocessFileLineNumbers "fixes\player_wearClothes.sqf";
player_tentPitch        = compile preprocessFileLineNumbers "fixes\tent_pitch.sqf";
player_fillWater        = compile preprocessFileLineNumbers "fixes\water_fill.sqf";
player_reloadMag        = compile preprocessFileLineNumbers "fixes\player_reloadMags.sqf";
player_packTent         = compile preprocessFileLineNumbers "fixes\player_packTent.sqf";

// Player sync hooks
player_countmagazines 	= compile preprocessFileLineNumbers "fixes\player_countmagazines.sqf";
player_humanityMorph 	= compile preprocessFileLineNumbers "fixes\player_humanityMorph.sqf";
player_switchModel 	    = compile preprocessFileLineNumbers "fixes\player_switchModel.sqf";

// Original functions being overridden
player_build_orig       = compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\player_build.sqf";
player_cook_orig        = compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\cook.sqf";
player_drink_orig       = compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\player_drink.sqf";
player_eat_orig         = compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\player_eat.sqf";
player_useMeds_orig     = compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\player_useMeds.sqf";
player_wearClothes_orig = compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\player_wearClothes.sqf";
player_tentPitch_orig   = compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\tent_pitch.sqf";
player_fillWater_orig   = compile preprocessFileLineNumbers "\z\addons\dayz_code\actions\water_fill.sqf";

if (isServer) then {
	hiveInUse = true;
	_serverMonitor = [] execVM "\z\addons\dayz_server\system\server_monitor.sqf";
};

if (!isDedicated) then {
	0 fadeSound 0;
	0 cutText [(localize "STR_AUTHENTICATING"), "BLACK FADED",60];
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = 	[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";

	// Create burn effect for each helicopter wreck
	{
		nul = [_x, 2, time, false, false] spawn BIS_Effects_Burn;
	} forEach allMissionObjects "UH1Wreck_DZ";

	// Set event handler
	{
		_x addEventHandler ["HandleDamage", { _this call vehicle_handleDamage }];
		_x addEventHandler ["Killed", { _this call vehicle_handleKilled }];
	} forEach vehicles;
};
