#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"
waituntil {!isnil "bis_fnc_init"};

BIS_MPF_remoteExecutionServer = {
	if ((_this select 1) select 2 == "JIPrequest") then {
		[nil,(_this select 1) select 0,"loc",rJIPEXEC,[any,any,"per","execVM","ca\Modules\Functions\init.sqf"]] call RE;
	};
};

BIS_Effects_Burn =			{};
server_playerLogin =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerLogin.sqf";
server_playerSetup =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSetup.sqf";
server_onPlayerDisconnect = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_onPlayerDisconnect.sqf";
server_updateObject =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateObject.sqf";
server_playerDied =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDied.sqf";
server_publishObj = 		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishObject.sqf";	//Creates the object in DB
server_deleteObj =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_deleteObj.sqf"; 	//Removes the object from the DB
server_playerSync =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSync.sqf";
zombie_findOwner =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\zombie_findOwner.sqf";
server_updateNearbyObjects =	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateNearbyObjects.sqf";
server_spawnCrashSite  =    compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnCrashSite.sqf";

spawnComposition = compile preprocessFileLineNumbers "ca\modules\dyno\data\scripts\objectMapper.sqf"; //"\z\addons\dayz_code\compile\object_mapper.sqf";
fn_bases = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fn_bases.sqf";

// vehicle_handleInteract = {
// 	private["_object"];
// 	_object = _this select 0;
// 	if (_object in needUpdate_objects) then {
// 		needUpdate_objects = needUpdate_objects - [_object];
// 	};
// 	[_object, "all",true] call server_updateObject;
// };

vehicle_handleServerKilled = {
	private["_unit","_killer"];
	_unit = _this select 0;
	_killer = _this select 1;
		
	[_unit, "killed"] call server_updateObject;
	
	_unit removeAllMPEventHandlers "MPKilled";
	_unit removeAllEventHandlers "Killed";
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "GetIn";
	_unit removeAllEventHandlers "GetOut";
};

check_publishobject = {
	private["_allowed","_allowedObjects","_object"];

	_object = _this select 0;
	_playername = _this select 1;
	_allowedObjects = ["TentStorage", "Hedgehog_DZ", "Sandbag1_DZ", "TrapBear", "Wire_cat1", "StashSmall", "StashMedium"];
	_allowed = false;

#ifdef OBJECT_DEBUG
	diag_log format ["DEBUG: Checking if Object: %1 is allowed published by %2", _object, _playername];
#endif

	if ((typeOf _object) in _allowedObjects || (typeOf _object) in allbuildables_class) then {
#ifdef OBJECT_DEBUG
		diag_log format ["DEBUG: Object: %1 published by %2 is Safe",_object, _playername];
#endif
		_allowed = true;
	};

	_allowed
};

//event Handlers
eh_localCleanup = {
	private ["_object"];
	_object = _this select 0;
	_object addEventHandler ["local", {
		if(_this select 1) then {
			private["_type","_unit"];
			_unit = _this select 0;
			_type = typeOf _unit;
			 _myGroupUnit = group _unit;
 			_unit removeAllMPEventHandlers "mpkilled";
 			_unit removeAllMPEventHandlers "mphit";
 			_unit removeAllMPEventHandlers "mprespawn";
 			_unit removeAllEventHandlers "FiredNear";
			_unit removeAllEventHandlers "HandleDamage";
			_unit removeAllEventHandlers "Killed";
			_unit removeAllEventHandlers "Fired";
			_unit removeAllEventHandlers "GetOut";
			_unit removeAllEventHandlers "GetIn";
			_unit removeAllEventHandlers "Local";
			clearVehicleInit _unit;
			deleteVehicle _unit;
			deleteGroup _myGroupUnit;
			_unit = nil;
			#ifdef SERVER_DEBUG
			diag_log ("CLEANUP: DELETED A " + str(_type) );
			#endif
		};
	}];
};

server_hiveWrite = {
	private["_data"];
	//diag_log ("ATTEMPT WRITE: " + _this);
	_data = "HiveExt" callExtension _this;
	//diag_log ("WRITE: " +str(_data));
};

server_hiveReadWrite = {
	private["_key","_resultArray","_data"];
	_key = _this;
	//diag_log ("ATTEMPT READ/WRITE: " + _key);
	_data = "HiveExt" callExtension _key;
	//diag_log ("READ/WRITE: " +str(_data));
	_resultArray = call compile format ["%1",_data];
	_resultArray
};

// server_characterSync = {
// 	private ["_characterID","_playerPos","_playerGear","_playerBackp","_medical","_currentState","_currentModel","_key"];
// 	_characterID = 	_this select 0;	
// 	_playerPos =	_this select 1;
// 	_playerGear =	_this select 2;
// 	_playerBackp =	_this select 3;
// 	_medical = 		_this select 4;
// 	_currentState =	_this select 5;
// 	_currentModel = _this select 6;
// 	
// 	_key = format["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:",_characterID,_playerPos,_playerGear,_playerBackp,_medical,false,false,0,0,0,0,_currentState,0,0,_currentModel,0];
// 	//diag_log ("HIVE: WRITE: "+ str(_key) + " / " + _characterID);
// 	_key call server_hiveWrite;
// };

//onPlayerConnected 		"[_uid,_name] spawn server_onPlayerConnect;";
onPlayerDisconnected 		"[_uid,_name] call server_onPlayerDisconnect;";

server_getDiff =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = 	0;
	if (_vNew < _vOld) then {
		//JIP issues
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

// dayz_objectUID = {
// 	private["_position","_dir","_key","_object"];
// 	_object = _this;
// 	_position = getPosATL _object;
// 	_dir = direction _object;
// 	_key = [_dir,_position] call dayz_objectUID2;
//     _key
// };

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

// BASE BUILDING 1.2 Build Array
build_baseBuilding_arrays = {

// ################################### BUILD LIST ARRAY SERVER SIDE ######################################## START
/*
Build list by Daimyo for SERVER side
Add and remove recipes, Objects(classnames), requirments to build, and town restrictions + extras
This method is used because we are referencing magazines from player inventory as buildables.
Main array (_buildlist) consist of 34 arrays within. These arrays contains parameters for player_build.sqf
From left to right, each array contains 3 elements, 1st: Recipe Array, 2nd: "Classname", 3rd: Requirements array. 
Check comments below for more info on parameters
*/
private["_isDestructable","_classname","_isSimulated","_disableSims","_objectSims","_objectSim","_requirements","_isStructure","_structure","_wallType","_removable","_buildlist","_build_townsrestrict"];
// Count is 34
// Info on Parameters (Copy and Paste to add more recipes and their requirments!):
//[TankTrap, SandBags, Wires, Logs, Scrap Metal, Grenades], "Classname", [_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown, _removable, _isStructure, _isSimulated, _isDestructable];
_buildlist = [
[[0, 1, 0, 0, 1, 1], "Grave", 						[[0,2.5,.1],[0,2,0], 	0, 	true, true, true, false, false, true, true, false, false, true, false]],//Booby Traps --1
[[2, 0, 0, 3, 1, 0], "Concrete_Wall_EP1", 			[[0,5,1.75],[0,2,0], 	0, 	true, false, true, false, false, true, false, false, false, true, false]],//Gate Concrete Wall --2
[[1, 0, 1, 0, 1, 0], "Infostand_2_EP1",				[[0,2.5,.6],[0,2,0], 	0, 	true, false, true, false, false, false, false, false, false, false, false]],//Gate Panel w/ KeyPad --3
[[3, 3, 2, 2, 0, 0], "WarfareBDepot",				[[0,18,2], 	[0,15,0], 	90, true, true, false, true, false, false, false, false, true, true, false]],//WarfareBDepot --4
[[4, 1, 2, 2, 0, 0], "Base_WarfareBBarrier10xTall", [[0,10,1], 	[0,10,0], 	0, 	true, true, false, true, false, false, false, false, false, true, false]],//Base_WarfareBBarrier10xTall --5 
[[2, 1, 2, 1, 0, 0], "WarfareBCamp",				[[0,12,1], 	[0,10,0], 	0, 	true, true, false, true, false, false, false, false, true, true, false]],//WarfareBCamp --6
[[2, 1, 1, 1, 0, 0], "Base_WarfareBBarrier10x", 	[[0,10,.6], [0,10,0], 	0, 	true, true, false, true, false, false, false, false, false, true, false]],//Base_WarfareBBarrier10x --7
[[2, 2, 0, 2, 0, 0], "Land_fortified_nest_big", 	[[0,12,1], 	[2,8,0], 	180,true, true, false, true, false, false, false, false, true, true, false]],//Land_fortified_nest_big --8
[[2, 1, 2, 2, 0, 0], "Land_Fort_Watchtower",		[[0,10,2.2],[0,8,0], 	90, true, true, false, true, false, false, false, false, true, true, false]],//Land_Fort_Watchtower --9
[[4, 1, 1, 3, 0, 0], "Land_fort_rampart_EP1", 		[[0,7,.2], 	[0,8,0], 	0, 	true, true, false, true, false, false, false, true, false, true, false]],//Land_fort_rampart_EP1 --10
[[2, 1, 1, 0, 0, 0], "Land_HBarrier_large", 		[[0,7,1], 	[0,4,0], 	0, 	true, true, true, false, false, false, false, false, false, true, false]],//Land_HBarrier_large --11
[[2, 1, 0, 1, 0, 0], "Land_fortified_nest_small",	[[0,7,1], 	[0,3,0], 	90, true, true, true, false, false, false, false, false, true, true, false]],//Land_fortified_nest_small --12
[[0, 1, 1, 0, 0, 0], "Land_BagFenceRound",			[[0,4,.5], 	[0,2,0], 	180,true, true, false, false, false, false, false, true, false, true, false]],//Land_BagFenceRound --13
[[0, 1, 0, 0, 0, 0], "Land_fort_bagfence_long", 	[[0,4,.3], 	[0,2,0], 	0, 	true, true, false, false, false, false, false, true, false, true, false]],//Land_fort_bagfence_long --14
[[6, 0, 0, 0, 2, 0], "Land_Misc_Cargo2E",			[[0,7,2.6], [0,5,0], 	90, true, false, false, true, false, false, false, false, false, true, false]],//Land_Misc_Cargo2E --15
[[5, 0, 0, 0, 1, 0], "Misc_Cargo1Bo_military",		[[0,7,1.3], [0,5,0], 	90, true, false, false, true, false, false, false, false, false, true, false]],//Misc_Cargo1Bo_military --16
[[3, 0, 0, 0, 1, 0], "Ins_WarfareBContructionSite",	[[0,7,1.3], [0,5,0], 	90, true, false, false, true, false, false, false, false, false, true, false]],//Ins_WarfareBContructionSite --17
[[1, 1, 0, 2, 1, 0], "Land_pumpa",					[[0,3,.4], 	[0,3,0], 	0, 	true, true, true, false, false, false, false, true, false, true, false]],//Land_pumpa --18
[[1, 0, 0, 0, 0, 0], "Land_CncBlock",				[[0,3,.4], 	[0,2,0], 	0, 	true, false, false, false, false, true, true, true, false, true, false]],//Land_CncBlock --19
[[4, 0, 0, 0, 0, 0], "Hhedgehog_concrete",			[[0,5,.6], 	[0,4,0], 	0, 	true, true, false, true, false, true, false, false, false, true, false]],//Hhedgehog_concrete --20
[[1, 0, 0, 0, 1, 0], "Misc_cargo_cont_small_EP1",	[[0,5,1.3], [0,4,0], 	90, true, false, false, false, false, false, false, true, false, true, false]],//Misc_cargo_cont_small_EP1 --21
[[1, 0, 0, 2, 0, 0], "Land_prebehlavka",			[[0,6,.7], 	[0,3,0], 	90, true, false, false, false, false, false, false, true, false, true, true]],//Land_prebehlavka(Ramp) --22
[[2, 0, 0, 0, 0, 0], "Fence_corrugated_plate",		[[0,4,.6], 	[0,3,0], 	0,	true, false, false, false, false, false, false, true, false, true, true]],//Fence_corrugated_plate --23
[[2, 0, 1, 0, 0, 0], "ZavoraAnim", 					[[0,5,4.0], [0,5,0], 	0, 	true, false, false, false, false, true, false, true, false, true, true]],//ZavoraAnim --24
[[0, 0, 7, 0, 1, 0], "Land_tent_east", 				[[0,8,1.7], [0,6,0], 	0, 	true, false, false, true, false, false, false, false, true, true, true]],//Land_tent_east --25
[[0, 0, 6, 0, 1, 0], "Land_CamoNetB_EAST",			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true]],//Land_CamoNetB_EAST --26
[[0, 0, 5, 0, 1, 0], "Land_CamoNetB_NATO", 			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true]],//Land_CamoNetB_NATO --27
[[0, 0, 4, 0, 1, 0], "Land_CamoNetVar_EAST",		[[0,10,1.2],[0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true]],//Land_CamoNetVar_EAST --28
[[0, 0, 3, 0, 1, 0], "Land_CamoNetVar_NATO", 		[[0,10,1.2],[0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true]],//Land_CamoNetVar_NATO --29
[[0, 0, 2, 0, 1, 0], "Land_CamoNet_EAST",			[[0,8,1.2], [0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true]],//Land_CamoNet_EAST --30
[[0, 0, 1, 0, 1, 0], "Land_CamoNet_NATO",			[[0,8,1.2], [0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true]],//Land_CamoNet_NATO --31
[[0, 0, 2, 2, 0, 0], "Fence_Ind_long",				[[0,5,.6], 	[-4,1.5,0], 0, 	true, false, true, false, false, false, false, true, false, true, true]], //Fence_Ind_long --32
[[0, 0, 2, 0, 0, 0], "Fort_RazorWire",				[[0,5,.8], 	[0,4,0], 	0, 	true, false, false, false, false, false, false, true, false, true, true]],//Fort_RazorWire --33
[[0, 0, 1, 0, 0, 0], "Fence_Ind",  					[[0,4,.7], 	[0,2,0], 	0, 	true, false, false, false, false, false, true, true, false, true, true]] //Fence_Ind 	--34 *** Remember that the last element in array does not get comma ***
];
// Build allremovables array for remove action
for "_i" from 0 to ((count _buildlist) - 1) do
{
	_removable = (_buildlist select _i) select _i - _i + 1;
	if (_removable != "Grave") then { // Booby traps have disarm bomb
	allremovables set [count allremovables, _removable];
	};
};
// Build classnames array for use later
for "_i" from 0 to ((count _buildlist) - 1) do
{
	_classname = (_buildlist select _i) select _i - _i + 1;
	allbuildables_class set [count allbuildables_class, _classname];
};


/*
*** Remember that the last element in ANY array does not get comma ***
Notice lines 47 and 62
*/
// Towns to restrict from building in. (Type exact name as shown on map, NOT Case-Sensitive but spaces important)
// ["Classname", range restriction];
// NOT REQUIRED SERVER SIDE, JUST ADDED IN IF YOU NEED TO USE IT
_build_townsrestrict = [
["Lyepestok", 1000],
["Sabina", 900],
["Branibor", 600],
["Bilfrad na moru", 400],
["Mitrovice", 350],
["Seven", 300],
["Blato", 300]
];
// Here we are filling the global arrays with this local list
allbuildables = _buildlist;
allbuild_notowns = _build_townsrestrict;

// ################################### BUILD LIST ARRAY SERVER SIDE ######################################## END

};
call compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fa_hiveMaintenance.sqf";
