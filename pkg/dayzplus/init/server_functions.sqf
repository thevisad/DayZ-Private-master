waituntil {!isnil "bis_fnc_init"};

BIS_MPF_remoteExecutionServer = {
    if ((_this select 1) select 2 == "JIPrequest") then {
        [nil,(_this select 1) select 0,"loc",rJIPEXEC,[any,any,"per","execVM","ca\Modules\Functions\init.sqf"]] call RE;
    };
};

BIS_Effects_Burn =			{};
object_spawnDamVehicle =	compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\object_spawnDamVehicle.sqf";
server_playerLogin =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerLogin.sqf";
server_playerSetup =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSetup.sqf";
server_onPlayerDisconnect = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_onPlayerDisconnect.sqf";
server_updateObject =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateObject.sqf";
server_playerDied =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDied.sqf";
server_publishObj = 		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishObject.sqf";
local_publishObj = 			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\local_publishObj.sqf";		//Creates the object in DB
local_deleteObj = 			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\local_deleteObj.sqf";		//Creates the object in DB
local_createObj = 			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\local_createObj.sqf";		//Creates the object in DB
server_playerSync =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSync.sqf";
zombie_findOwner =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\zombie_findOwner.sqf";
server_updateNearbyObjects =	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateNearbyObjects.sqf";
fnc_plyrHit   = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fnc_plyrHit.sqf";

//Get instance name (e.g. dayz_1.chernarus)
fnc_instanceName = {
	"dayz_" + str(dayz_instance) + "." + worldName
};
vehicle_handleInteract = {
	private["_object"];
	_object = _this select 0;
	[_object, "all"] call server_updateObject;
};

player_combatLogged = {};

check_publishobject = {
		private["_allowed","_allowedObjects","_object"];
		
		_object = _this select 0;
		_allowedObjects = ["TentStorage","Hedgehog_DZ","Sandbag1_DZ","BearTrap_DZ","Wire_cat1","Gate1_DZ","LadderLarge","LadderSmall","Sandbag3_DZ","Sandbag2_DZ","Scaffolding","HBarrier","Wire2","SandBagNest","WatchTower","DeerStand","CamoNet"];
		_allowed = false;
		
		diag_log format ["DEBUG: Checking if Object: %1 is allowed", _object];
		
		if ((typeOf _object) in _allowedObjects) then {
				diag_log format ["DEBUG: Object: %1 Safe",_object];
				_allowed = true;
		};
	};

eh_localCleanup = {
	private ["_object"];
	_object = _this select 0;
	_object addEventHandler ["local", {
		if(_this select 1) then {
			private["_type","_unit"];
			_unit = _this select 0;
			_type = typeOf _unit;
			deleteVehicle _unit;
			diag_log ("CLEANUP: DELETED A " + str(_type) );
		};
	}];
};

server_characterSync = {
	private ["_characterID","_playerPos","_playerGear","_playerBackp","_medical","_currentState","_currentModel","_key"];
	_characterID = 	_this select 0;	
	_playerPos =	_this select 1;
	_playerGear =	_this select 2;
	_playerBackp =	_this select 3;
	_medical = 		_this select 4;
	_currentState =	_this select 5;
	_currentModel = _this select 6;
	
	_key = format["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:",_characterID,_playerPos,_playerGear,_playerBackp,_medical,false,false,0,0,0,0,_currentState,0,0,_currentModel,0];
	_key call server_hiveWrite;
};

fnc_buildWeightedArray = 	compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\fn_buildWeightedArray.sqf";		//Checks which actions for nearby casualty

onPlayerDisconnected 		"[_uid,_name] call server_onPlayerDisconnect;";

server_hiveWrite = {
	private["_data"];
	_data = "HiveEXT" callExtension _this;
};

server_hiveReadWrite = {
	private["_key","_resultArray","_data"];
	_key = _this select 0;
	_data = "HiveEXT" callExtension _key;
	_resultArray = call compile format ["%1;",_data];
	_resultArray;
};

spawn_UH1YCrashSite = {
	private["_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray"];
	
	if (isDedicated) then {
	_position = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;
	_veh = createVehicle ["UH1YWreck_DZ",_position, [], 0, "CAN_COLLIDE"];
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
	_veh setVariable ["ObjectID",1,true];
	dayzFire = [_veh,2,time,false,false];
	publicVariable "dayzFire";
	if (isServer) then {
		nul=dayzFire spawn BIS_Effects_Burn;
	};
	
	_num = round(random 4) + 3;
	_config = 		configFile >> "CfgBuildingLoot" >> "UH1YCrash";
	_itemType =		[] + getArray (_config >> "itemType");
	_itemChance =	[] + getArray (_config >> "itemChance");
	
	_weights = [];
	_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
	for "_x" from 1 to _num do {
		_index = _weights call BIS_fnc_selectRandom;
		if (count _itemType > _index) then {
			_iArray = _itemType select _index;
			_iArray set [2,_position];
			_iArray set [3,5];
			_iArray call spawn_loot;
			_nearby = _position nearObjects ["WeaponHolder",20];
			{
				_x setVariable ["permaLoot",true];
			} forEach _nearBy;
		};
	};
	};
};

spawn_UH60CrashSite = {
	private["_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray"];
	
	if (isDedicated) then {
	_position = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;
	_veh = createVehicle ["UH60Wreck_DZ",_position, [], 0, "CAN_COLLIDE"];
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
	_veh setVariable ["ObjectID",1,true];
	dayzFire = [_veh,2,time,false,false];
	publicVariable "dayzFire";
	if (isServer) then {
		nul=dayzFire spawn BIS_Effects_Burn;
	};
	
	_num = round(random 4) + 3;
	_config = 		configFile >> "CfgBuildingLoot" >> "UH60Crash";
	_itemType =		[] + getArray (_config >> "itemType");
	_itemChance =	[] + getArray (_config >> "itemChance");
	
	_weights = [];
	_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
	for "_x" from 1 to _num do {
		_index = _weights call BIS_fnc_selectRandom;
		if (count _itemType > _index) then {
			_iArray = _itemType select _index;
			_iArray set [2,_position];
			_iArray set [3,5];
			_iArray call spawn_loot;
			_nearby = _position nearObjects ["WeaponHolder",20];
			{
				_x setVariable ["permaLoot",true];
			} forEach _nearBy;
		};
	};
	};
};

server_getDiff =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = 	0;
	if (_vNew < _vOld) then {
		_vNew = _vNew + _vOld;
		_object getVariable[(_variable + "_CHK"),_vNew];
	} else {
		_result = _vNew - _vOld;
		_object setVariable[(_variable + "_CHK"),_vNew];
	};
	_result
};

server_getDiff2 =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = _vNew - _vOld;
	_object setVariable[(_variable + "_CHK"),_vNew];
	_result
};

dayz_objectUID = {
	private["_position","_dir","_key","_object"];
	_object = _this;
	_position = getPosATL _object;
	_dir = direction _object;
	_key = [_dir,_position] call dayz_objectUID2;
    	_key
};

dayz_objectUID2 = {
	private["_position","_dir","_key"];
	_dir = _this select 0;
	_key = "";
	_position = _this select 1;
	{
		_x = _x * 10;
		if ( _x < 0 ) then { _x = _x * -10 };
		_key = _key + str(round(_x));
	} forEach _position;
	_key = _key + str(round(_dir));
	_key
};

dayz_recordLogin = {
	private["_key"];
	_key = format["CHILD:103:%1:%2:%3:",_this select 0,_this select 1,_this select 2];
	_key call server_hiveWrite;
};