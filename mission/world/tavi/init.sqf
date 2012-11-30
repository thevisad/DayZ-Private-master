startLoadingScreen ["","DayZ_loadingScreen"];
enableSaving [false, false];

dayZ_instance = 1;	//The instance
hiveInUse	=	true;
initialized = false;
dayz_previousID = 0;
arr_survivor_spawns_alt = [[[4019.42,6356.66,0],[3885.74,6441.42,0],[3627.36,6476.23,0],[3447.86,6537.82,0],[4062.69,6624.22,0],[4327.89,6719.37,0],[4380.21,7371.52,0],[4109.74,6787.41,0],[3710.97,6599.69,0],[3263.29,6531.64,0],[3824.59,8055.27,0],[3649.52,7962.57,0],[4207.17,7819.19,0],[3070.67,7826.18,0.001],[3189.24,6757.61,0],[4744.44,7728.05,0],[4402.13,7478,0],[4607.71,6646.82,0],[4433.69,6153.01,0],[4512.63,6688.07,0],[4449.69,8000.62,0],[4108.86,6532.78,0],[4669.18,6031.18,0],[4524.06,6177.92,0],[4799.35,6566.98,0],[3097.9,6621.89,0],[3158.32,6869.78,0],[2963.38,6764.66,0],[2733.29,6996.52,0],[2542.32,6576.83,0],[2799.13,6579.82,0],[2452.71,6840.6,0],[2496.4,6955.43,0],[3102.87,7317.3,0],[2945.37,7224.94,0],[3121.37,7761.26,0],[2862.07,7839.67,0],[2547.44,7862.79,0],[2455.68,7723.02,0],[2721.23,7523.38,0],[2930.22,7527.76,0],[3104.41,7586.93,0],[2774.93,7651.96,0],[2521.31,7900.24,0],[2516.84,8046.29,0],[2806.55,7922.47,0],[2545.56,7489.7,0],[2468.38,7272.27,0],[2682.77,7142.22,0],[2537.4,6941.18,0]],[[8819.83,19828.7,0],[9137.27,19774.8,0],[9084.92,19868.5,0],[9277.66,19738.6,0],[9039.55,19614.8,0],[8930.66,20018.2,0],[8663.95,20047,0],[8784,20314.9,0],[9596.83,20005.6,0],[8337.38,19846.9,0],[8221.04,20118.7,0],[8431.09,20236.7,0],[8236.91,19999.2,0],[8333.5,19846.4,0],[8314.28,19597.6,0],[8419.41,19490.1,0],[8241.08,19567.4,0],[8170.85,19215.6,0],[8828.63,18920,0],[8751.06,18883.6,0],[7697.77,19856.2,0],[7955.51,19584.8,0],[8152.28,20312,0],[9293.28,19602.6,0],[8303.17,19617.3,0],[8272.23,19774,0],[8459.08,19092.7,0],[8104.4,19992,0],[8223.63,20170.4,0],[8517.62,20248.8,0],[8927.6,20434.3,0]]];

call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf"; //Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";	//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf"; //Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf"; //Compile regular functions
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

	// Create burn effect for each helicopter wreck
	{
		nul = [_x, 2, time, false, false] spawn BIS_Effects_Burn;
	} forEach allMissionObjects "UH1Wreck_DZ";
};
