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
arr_survivor_spawns_alt = [[[8401.41,18601,0],[8200.65,18597.6,0],[8399.73,18806.3,0],[8204.42,18799.4,0],[8374.1,18975,0],[8204.16,18905.5,0],[8097.43,19001.1,0],[8201.47,19071.2,0],[7998.67,19091.4,0],[8193.43,19291,0],[8000.37,19291.5,0],[8202.77,19503.3,0],[8000.07,19398.4,0],[7901.34,19504.8,0],[8108.82,19594.5,0],[8067.63,19734.5,0],[7885.56,19702.8,0],[7735.23,19796.4,0],[7735.23,19796.4,0],[8119.11,19982.3,0],[7849.48,20059.1,0],[7699.22,20225.4,0],[7897.05,20197.3,0],[8154.46,20248.9,0],[8201.28,20404.1,0],[7983.36,20429.1,0],[8191.29,20498.1,0],[8405.5,20595.7,0],[8499.21,20695,0],[8654.67,20609.2,0],[8915.86,20692.8,0],[8801.14,20395.1,0],[9096.56,20539.4,0],[9306.28,20602.6,0],[9281.48,20410.9,0],[9500.22,20401.9,0],[8990.57,20284.6,0],[8900.36,20198.9,0],[9105.58,20092.9,0],[9401,20298.1,0],[9703.18,20291.4,0],[9915.17,20203.4,0],[9722.76,20012.3,0],[9304.08,19901.3,0],[9403.25,19700.5,0],[9603.96,19797.5,0],[9497.97,19594.5,0],[9538.56,19409.6,0],[9716.33,19497.7,0],[9812.99,19692.7,0]],[[4019.42,6356.66,0],[3885.74,6441.42,0],[3627.36,6476.23,0],[3447.86,6537.82,0],[4062.69,6624.22,0],[4327.89,6719.37,0],[4380.21,7371.52,0],[4109.74,6787.41,0],[3710.97,6599.69,0],[3263.29,6531.64,0],[3824.59,8055.27,0],[3649.52,7962.57,0],[4207.17,7819.19,0],[3070.67,7826.18,0.001],[3189.24,6757.61,0],[4744.44,7728.05,0],[4402.13,7478,0],[4607.71,6646.82,0],[4433.69,6153.01,0],[4512.63,6688.07,0],[4449.69,8000.62,0],[4108.86,6532.78,0],[4669.18,6031.18,0],[4524.06,6177.92,0],[4799.35,6566.98,0],[3097.9,6621.89,0],[3158.32,6869.78,0],[2963.38,6764.66,0],[2733.29,6996.52,0],[2542.32,6576.83,0],[2799.13,6579.82,0],[2452.71,6840.6,0],[2496.4,6955.43,0],[3102.87,7317.3,0],[2945.37,7224.94,0],[3121.37,7761.26,0],[2862.07,7839.67,0],[2547.44,7862.79,0],[2455.68,7723.02,0],[2721.23,7523.38,0],[2930.22,7527.76,0],[3104.41,7586.93,0],[2774.93,7651.96,0],[2521.31,7900.24,0],[2516.84,8046.29,0],[2806.55,7922.47,0],[2545.56,7489.7,0],[2468.38,7272.27,0],[2682.77,7142.22,0],[2537.4,6941.18,0]],[[3566.18,7900.14,0],[6544.10,4700.80,0],[7674.88,3408.30,0],[9305.27,1905.47,0],[11602.08,383.86,0],[11285.17,2307.04,0],[10124.68,4188.57,0],[10834.32,6071.59,0],[9642.36,6554.14,0],[8729.80,6532.97,0],[7447.90,8751.99,0],[6606.06,10236.27,0],[5537.96,10161.5,0],[4840.43,8574.13,0],[7703.58,5597.83,0],[10234.39,7817.56,0],[10640.3,6861.75,0],[8561.85,3333.7,0],[8705.99,5150.78,0],[9015.23,4299.58,0],[6704.3,9718.05,0],[10762.5,674.399,0],[7444.85,6990.47,0],[8714.29,8649.08,0],[9968.79,3305.49,0],[12946.82,8454.67,0],[14704.23,7451.44,0],[15975.83,7435.72,0],[16063.51,6248.43,0],[18420.04,5038.24,0],[18329.51,6552.88,0],[17703.17,12301.36,0],[16270.75,15830.58,0],[14328.09,19114.85,0],[12764.12,19450.96,0],[10594.29,19899.37,0],[15254.05,13006.66,0],[15596.24,14841.83,0],[11377.4,14732.1,0],[12986,11815.1,0],[14482.6,12370.3,0],[17416.2,6974.35,0],[16620.8,9284.97,0],[16130.4,11242,0],[14082.3,13049.5,0],[14995.7,8502.94,0],[16456.9,8427.66,0],[10822.1,16799.5,0],[13168.2,14812.1,0],[12637.6,13335.9,0]]];

//disable greeting menu 
player setVariable ["BIS_noCoreConversations", true];
//disable radio messages to be heard and shown in the left lower corner of the screen
enableRadio false;

//Load in compiled functions
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";				//Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";				//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";	//Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";				//Compile regular functions
progressLoadingScreen 1.0;
call compile preprocessFileLineNumbers "fixes\comaptibiliyFiles.sqf"; //Compile patches to fix all the dayz shit.

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
	//Conduct map operations
	0 fadeSound 0;
	waitUntil {!isNil "dayz_loadScreenMsg"};
	dayz_loadScreenMsg = (localize "STR_AUTHENTICATING");
	
	//Run the player monitor
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = 	[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";	
};