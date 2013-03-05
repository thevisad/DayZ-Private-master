private["_hcx","_helicrash","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray","_wpos","_lootpos"];
_hcx = _this select 0;
waitUntil{!isNil "BIS_fnc_selectRandom"};
if (isDedicated) then {
	/*
	"Land_mi8_crashed";4210.79;8913.34 _hcx == 1
	"Land_mi8_crashed";5433.65;9282.45 _hcx == 2
	"Land_mi8_crashed";5645.02;7973.14 _hcx == 3
	"Land_mi8_crashed";5363.63;7161.82 _hcx == 4
	"Land_mi8_crashed";2814.39;6391.89 _hcx == 5
	"Land_mi8_crashed";4335.19;6424.07 _hcx == 6
	"Land_mi8_crashed";4073.73;6457.54 _hcx == 7
	"Land_mi8_crashed";5496.03;5985.08 _hcx == 8
	"Land_wreck_c130j_ep1";3189.98;7507.8 _hcx == 9
	*/
	_helicrash = [0,0,0];
	switch (_hcx) do {
		case 1: {
			_helicrash = ([4210.79,8913.34,0] nearestObject "Land_mi8_crashed");
		};
		case 2: {
			_helicrash = ([5433.65,9282.45,0] nearestObject "Land_mi8_crashed");
		};
		case 3: {
			_helicrash = ([5645.02,7973.14,0] nearestObject "Land_mi8_crashed");
		};
		case 4: {
			_helicrash = ([5363.63,7161.82,0] nearestObject "Land_mi8_crashed");
		};
		case 5: {
			_helicrash = ([2814.39,6391.89,0] nearestObject "Land_mi8_crashed");
		};
		case 6: {
			_helicrash = ([4335.19,6424.07,0] nearestObject "Land_mi8_crashed");
		};
		case 7: {
			_helicrash = ([4073.73,6457.54,0] nearestObject "Land_mi8_crashed");
		};
		case 8: {
			_helicrash = ([5496.03,5985.08,0] nearestObject "Land_mi8_crashed");
		};
		case 9: {
			_helicrash = ([3189.98,7507.8 ,0] nearestObject "Land_wreck_c130j_ep1");
		};
		default {
			diag_log("ERROR: Cannot spawn helicrash loot (objNull)!");
		};
	};
	
	diag_log("DEBUG: Spawning HeliCrashNamalsk permaLoot on helicrash #" + str(_hcx) + " " + str(getPos _helicrash) + "");

	_config = 		configFile >> dayzNam_buildingLoot >> "HeliCrashNamalsk";
	_itemType =		[] + getArray (_config >> "itemType");
	_itemChance =	[] + getArray (_config >> "itemChance");
	
	waituntil {!isnil "fnc_buildWeightedArray"};
	
	_weights = [];
	_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
	_lootpos = [] + getArray (configFile >> dayzNam_buildingLoot >> (typeOf _helicrash) >> "lootPos");

	if (_helicrash != objNull) then {
		for "_x" from 1 to (count _lootpos) do {
			//create lootpos
			_wpos = _helicrash modelToWorld (_lootpos select (_x - 1));
			//create loot
			_index = _weights call BIS_fnc_selectRandom;
			sleep 1;
			if (count _itemType > _index) then {
				//diag_log ("DW_DEBUG: " + str(count (_itemType)) + " select " + str(_index));
				_iArray = _itemType select _index;
				_iArray set [2,_wpos];
				_iArray set [3,5];
				_iArray call spawn_loot;
				_nearby = _wpos nearObjects ["WeaponHolder",20];
				{
					_x setVariable ["permaLoot",true];
				} forEach _nearBy;
			};
		};
	};
};