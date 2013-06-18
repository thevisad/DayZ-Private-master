/****************************************************************************
init.sqf for DayZ Lingor - Skaronator.com Version
@Autor: DayZ Community & Skaronator
@Version: For Clientversion +2.3
@Last Edit: 09/06/2013
*****************************************************************************/

startLoadingScreen ["","RscDisplayLoadCustom"];
cutText ["","BLACK OUT"];
enableSaving [false, false];

/***********NOT USED AT THIS MOMENT********************************************
//Lingor Island Spawnpoints by Skaronator.com Drassen, Chupinka, Random = 150 Spawnpoints!
survivor_spawns = [
[[1186.1508,20.643276,2325.3247],[781.5116,27.090317,2123.7561],[583.45642,21.624538,1783.7158],[714.46753,30.547974,984.87427],[524.24353,21.799231,753.18298],[1290.6537,9.5163479,380.82214],[1547.0425,18.399752,971.08276],[1571.8542,79.616058,692.50244],[1218.9749,38.489616,910.40222],[1020.4802,54.813854,684.22729],[1260.328,8.0164394,1633.0579],[1850.0221,6.5649304,2239.0383],[437.58673,21.086065,1352.4261],[1298.8821,12.67374,1220.99],[1730.8928,19.84553,1233.7561],[1942.6586,4.4572601,627.14783],[2337.3997,29.377544,848.93066],[1963.9459,5.7051468,1253.7982],[972.77795,21.378481,1473.1268],[784.28436,15.894645,1969.6088],[1215.1266,42.048744,1911.8793],[1507.4839,14.453661,1730.99],[559.27301,27.436359,2467.1318],[2021.4573,14.978045,1579.1144],[434.57147,19.492674,1696.5381],[1265.9138,26.514395,2166.2329],[823.34619,27.038048,1265.9845],[1454.1882,76.464157,840.32349],[529.93127,30.487698,2227.3906],[429.68112,6.8025331,1151.0071]],
[[7425.5278,4.9990349,797.23022],[8687.209,7.6735353,485.16113],[7363.2373,4.5996203,1849.978],[7495.7998,7.7556543,2079.1284],[6958.9219,6.9559579,2209.5454],[8421.1797,4.9877572,1964.5923],[8340.5576,4.9877572,2528.9595],[8251.2939,4.9764762,2954.0596],[7826.4038,4.9764762,2681.377],[7557.4258,4.9877572,2936.1982],[7913.2861,6.5495377,3011.2158],[7334.8628,5.6078014,2589.688],[7482.4438,8.393837,2686.1389],[7272.3369,4.222692,2261.1743],[8081.667,4.9962177,1085.8771],[8353.0762,4.9877572,684.68018],[8553.5762,5.6765065,1386.7767],[8257.7158,4.9877572,1203.302],[8360.4111,4.9877572,1787.9736],[7375.0557,4.9990349,1099.0656],[7624.458,4.9764762,1629.9188],[6776,24.417912,1270.3094],[6792.0347,9.0008364,2076.5828],[8069.4707,6.1830096,2204.8059],[6731.9438,5.9859552,2477.8608],[7038.4941,4.5023417,2982.1685],[7382.0239,7.6778202,2956.6602],[6778.1631,19.658604,3303.0439],[7952.3496,20.48563,1682.0966],[7919.3857,5.1823578,726.82129],[6160.9668,14.690277,1683.5181],[5971.7949,23.153116,2820.1611],[8303.4473,4.9764762,2674.6326],[7437.792,5.0068898,2650.0879],[7809.2871,5.2619376,2902.5483],[7588.3203,5.1271811,1972.0599],[7293.8125,4.4370794,1746.0535],[7243.144,5.2401738,2074.5024],[8112.4805,6.254715,519.21265]],
[[3762.8994,10.789688,1018.1985],[4348.2222,14.427014,937.11548],[3861.2688,66.24839,1731.2549],[3471.5845,9.9035578,5141.6504],[646.48633,30.126638,4639.1523],[903.45447,10.882351,4975.104],[1058.9309,6.0114074,5046.3984],[1134.2333,4.9420061,5355.8423],[546.61664,20.000235,5292.3608],[715.63141,39.225452,5664.5459],[1169.1686,44.633778,5781.8105],[1243.9088,25.506575,5538.7852],[826.31781,10.873388,6397.9971],[2148.9309,8.1767502,6240.8799],[2051.2175,23.731598,5530.3682],[1484.6229,5.602006,4941.1816],[1713.7244,4.9977899,4798.5957],[1738.2744,12.078233,4434.7144],[7545.6245,2.1515603,8262.2773],[8620.1807,15.08951,8964.4326],[8518.6055,4.4253044,7730.7773],[9158.0625,3.5910759,8610.6875],[9070.2842,16.984344,7003.3081],[8150.2861,10.955025,6691.9639],[7120.6904,9.0766678,7226.3774],[6657.7295,12.212019,6072.1885],[5891.1553,10.396598,7047.9648],[6336.8086,12.212019,5640.8496],[6927.8364,3.8350449,3959.0295],[3356.3462,33.872723,7587.2158],[5710.8867,33.185799,4308.1465],[5362.5439,47.917934,3754.4707],[3906.4463,35.250553,4625.3359],[2419.0884,15.917201,4813.6519],[5362.5439,47.917934,3754.4707],[3906.4463,35.250553,4625.3359],[2419.0884,15.917201,4813.6519],[2835.6406,5.8336892,5398.3477],[3014.8445,14.073066,6432.5205],[3738.5283,62.93261,8259.5117],[5190.2153,18.08556,7087.8623],[3188.1133,69.14241,1466.7151],[4423.2583,23.975863,1639.0417],[5791.7529,9.1335478,953.75854],[2830.3062,50.853077,2884.4551],[1753.6082,98.183495,3676.5352],[6123.7354,47.947544,3602.6074],[5036.4824,39.804905,6052.7725],[833.36633,28.907375,1722.793],[8212.6699,5.4711289,1494.3793],[8345.2324,8.0612488,514.40918],[3630.7842,172.60765,3533.8611],[2857.1729,25.378683,4510.2803],[2317.2537,14.259986,8052.3799],[1542.5507,26.132631,2599.4346],[909.11713,19.767656,2020.401],[1401.2817,69.161255,506.70593],[498.98041,21.327744,1505.1978],[2905.1172,17.273829,2052.3157],[4194.7705,12.032715,2521.9263],[3985.145,61.055408,2795.4854],[8045.6348,4.9877572,1903.5785],[5543.4971,27.811432,1648.938],[4080.9304,44.459602,3897.666],[4668.8252,9.7330732,4539.6475],[5579.3452,34.456001,5518.7598],[5238.7959,20.02767,4665.1753],[7067.0049,11.822887,5188.8027],[8492.6768,3.7807252,2239.4641],[2502.9956,131.10704,3701.8022],[4564.0215,31.192627,1313.5333],[4779.8208,17.732349,2295.3906],[2745.1377,12.909275,1292.97],[4173.5259,17.461523,1950.9692],[4039.936,12.212019,1334.0961],[4158.1123,23.660297,1668.2355],[4625.6777,6.2078276,1107.9077],[4368.7739,23.682859,1221.0022],[2164.5334,10.091545,1889.2828],[5730.3672,21.595398,2315.9534]]
]
*************COMING SOON!******************************************************/

dayZ_instance = 1;	//The instance
//dayZ_serverName="Lingor1"; // server name (country code + server number)
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;

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
	"PVDZ_sec_atp"	addPublicVariableEventHandler { diag_log format["%1", _this select 1];};
};

if (!isDedicated) then {
	//Conduct map operations
	0 fadeSound 0;
	waitUntil {!isNil "dayz_loadScreenMsg"};
	dayz_loadScreenMsg = (localize "STR_AUTHENTICATING");
	
	//Run the player monitor
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = 	[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";
	[] execVM "\z\addons\dayz_code\system\antihack.sqf";
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

#include "\z\addons\dayz_code\system\REsec.sqf"