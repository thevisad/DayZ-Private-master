private["_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray"];

waitUntil{!isNil "BIS_fnc_selectRandom"};
if (isDedicated) then {
	_position = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;
	diag_log("DEBUG: Spawning a medical care package at " + str(_position));
	_veh = createVehicle ["Misc_cargo_cont_net1",_position, [], 0, "CAN_COLLIDE"];
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
	_veh setVariable ["ObjectID",1,true];
	
	_num = round(random 3) + 1;
	_config = 		configFile >> dayzNam_buildingLoot >> "HospitalNamalsk";
	_itemType =		[] + getArray (_config >> "itemType");	
	_itemChance =	[] + getArray (_config >> "itemChance");
	
	waituntil {!isnil "fnc_buildWeightedArray"};
	
	_weights = [];
	_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
	//diag_log ("DW_DEBUG: _weights: " + str(_weights));	
	for "_x" from 1 to _num do {
		//create loot
		_index = _weights call BIS_fnc_selectRandom;
		sleep 1;
		if (count _itemType > _index) then {
			//diag_log ("DW_DEBUG: " + str(count (_itemType)) + " select " + str(_index));
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