private ["_hcx", "_obj", "_type", "_config", "_positions", "_itemTypes", "_lootChance", "_countPositions", "_bias", "_rnd", "_iPos", "_nearBy", "_index", "_weights", "_cntWeights", "_itemType", "_qty", "_i"];
_hcx = _this select 0;
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

	_obj = _helicrash;
	_type = typeOf _obj;
	_config = configFile >> dayzNam_buildingLoot >> _type;
	_positions = [] + getArray (_config >> "lootPos");
	_itemTypes = [] + getArray (_config >> "lootType");
	_lootChance = 0.65;
	_countPositions = count _positions;
	_qty = 0;
	
	_bias = 50 max 50;
	_bias = 100 min _bias;
	_bias = (_bias + random(100 - _bias)) / 100;
	{
		if (count _x == 3) then {
			_rnd = (random 1) / _bias;
			_iPos = _obj modelToWorld _x;
			_nearBy = nearestObjects [_iPos, ["ReammoBox"], 2];
	
			if (count _nearBy > 0) then {
				_lootChance = _lootChance + 0.05;
			};
				
			if (_rnd <= _lootChance) then {
				if (count _nearBy == 0) then {
					_i = 0;
					_index = 0;
					{
						if (_x == _type) then {
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
					[_itemType select 0, _itemType select 1 , _iPos, 0.0] call spawn_loot;
					_qty = _qty +1;
				};
			};
			sleep ((random 3) / 1000);
		} else {
			diag_log(format["%1 Illegal loot position #%3 from %2 in building %4 -- skipped", __FILE__, configName _config, _forEachIndex+1, typeOf _obj]);
		};
	} forEach _positions;
	_nearby = (getPos _helicrash) nearObjects ["WeaponHolder",20];
	{
		_x setVariable ["permaLoot",true];
	} forEach _nearBy;
	diag_log("DEBUG: Spawned HeliCrashNamalsk permaLoot on helicrash #" + str(_hcx) + " " + str(getPos _helicrash) + "");
};