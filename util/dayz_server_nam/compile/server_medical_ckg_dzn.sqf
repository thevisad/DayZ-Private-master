private["_hcx", "_y", "_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray"];

if (isDedicated) then {
	_position = [getMarkerPos "center", 0, 4000, 10, 0, 2000, 0] call BIS_fnc_findSafePos;
	diag_log("DEBUG: Spawning a medical care package at " + str(_position));
	_veh = createVehicle ["Misc_cargo_cont_net1", _position, [], 0, "CAN_COLLIDE"];
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
	_veh setVariable ["ObjectID",1,true];
	_veh setPos [(_position select 0) - 2, (_position select 1) + 2, 0];
	
	_num = round(random 3) + 1;
	_config = configFile >> dayzNam_buildingLoot >> "HospitalNamalsk";
	_itemTypes = [] + getArray (_config >> "lootType");
	_lootChance = 1.00;
	_qty = 0;

	for "_y" from 1 to _num do {
		_i = 0;
		_index = 0;
		{
			if (_x == "HospitalNamalsk") then {
				_index = _i;
			} else {
				_i = _i + 1;
			};
		} forEach dayz_CBLBase;
		_weights = dayz_CBLChances select _index;
		_cntWeights = count _weights;
		_index = floor(random _cntWeights);
		_index = _weights select _index;
		_itemType = _itemTypes select _index;
		if ((_y mod 2) != 0) then {
			_position = [(_position select 0) - ((random 8) min 3), (_position select 1) - ((random 8) min 3), 0];
		} else {
			_position = [(_position select 0) + ((random 8) min 3), (_position select 1) + ((random 8) min 3), 0];
		};
		[_itemType select 0, _itemType select 1 , _position, 0.0] call spawn_loot;
		_qty = _qty + 1;
		sleep ((random 3) / 1000);
	};
	_nearby = _position nearObjects ["WeaponHolder",20];
	{
		_x setVariable ["permaLoot",true];
	} forEach _nearBy;
};