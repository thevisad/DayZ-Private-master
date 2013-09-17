/*
       Created exclusively for ArmA2:OA - DayZMod.
       Please request permission to use/alter/distribute from project leader (R4Z0R49).
*/
private ["_b","_amount","_radius","_lootMinRadius","_lootMaxRadius","_objectMinRadius","_objectMaxRadius","_randomObjects","_guaranteedObjects","_randomLoot","_guaranteedLoot","_nextPos","_basePos","_tmpobject","_qty","_baseClass","_centerPos","_placeSearchRadius","_placeMinDistance","_addLoot","_addWrecks","_placeSearchExpr","_small","_medium","_large","_placePrecision","_campList","_time"];

_qty = _this select 0;
_centerPos = getMarkerPos (_this select 1);
_placeSearchRadius = _this select 2;
_placeMinDistance = _this select 3;

// add some loot around the camp
_addLoot = {
private ["_clutter","_index","_lootMaxRadius2","_itemType","_position","_item","_nearby","_basePos","_baseClass","_lootMinRadius","_lootMaxRadius","_randomLoot","_guaranteedLoot","_lootTable","_itemTypes","_weights","_cntWeights","_i","_timeExit"];
	_timeExit = time;
	_basePos = _this select 0;
	_baseClass = _this select 1;
	_lootMinRadius = _this select 2;
	_lootMaxRadius = _this select 3;
	_randomLoot = _this select 4;
	_guaranteedLoot = _this select 5;
	_lootMaxRadius2 = _lootMaxRadius + 5;
	
	_lootTable = "InfectedCamps";
	_itemTypes =	[] + getArray (configFile >> "CfgBuildingLoot" >> _lootTable >> "lootType");
	_index = dayz_CBLBase find _lootTable;
	_weights =	dayz_CBLChances select _index;
	_cntWeights = count _weights;
	_i = 0;
	
	while {(_i < (round(random _randomLoot) + _guaranteedLoot)) && (round(time - _timeExit) < 10)} do { //timeout
		//create loot
		_index = floor(random _cntWeights);
		_index = _weights select _index;
		_itemType = _itemTypes select _index;
		
		_position = [_basePos,_lootMinRadius,_lootMaxRadius,0,0,0,0] call BIS_fnc_findSafePos;
		_position = [_position select 0,_position select 1,0];
		
		_item = [_itemType select 0, _itemType select 1, _position, _lootMaxRadius] call spawn_loot;
		if (dayz_spawnInfectedSite_clutterCutter == 1) then { // shift loot upward to 5cm
			_position set [2,0.05];
			_item setPosATL _position;
		} else {
			if (dayz_spawnInfectedSite_clutterCutter >= 2) then { // cutterclutter
				_clutter = createVehicle ["ClutterCutter_small_2_EP1", _position, [], 0, "CAN_COLLIDE"];
				_clutter setPosATL _position;
				if (dayz_spawnInfectedSite_clutterCutter == 3) then { // debug
					createVehicle ["Sign_sphere100cm_EP1", [_position select 0, _position select 1, 0.30], [], 0, "CAN_COLLIDE"];					
				};
			};
		};
	
		diag_log(format["Infected Camps: Loot spawn at '%1:%3' with loot table '%2'", _baseClass, str(_itemType),_position]); 
	
		// ReammoBox is preferred parent class here, as WeaponHolder wouldn't match MedBox0 and other such items.
		_nearby = _basePos nearObjects ["ReammoBox", _lootMaxRadius2];
		{
			_x setVariable ["permaLoot",true];
		} forEach _nearby;

		_i = _i + 1;
	};
};

// add some dead bodies and veh wrecks all around
_addWrecks = {
	private ["_randomObjects","_guaranteedObjects","_position","_basePos","_objectMinRadius","_objectMaxRadius","_Bodys","_randomvehicle","_chance","_DeadBody","_wreck","_z"];
	_basePos = _this select 0;
	_objectMinRadius = _this select 1;
	_objectMaxRadius = _this select 2;
	_randomObjects = _this select 3;
	_guaranteedObjects = _this select 4;
	_z = 0;

    while {_z < ((round(random _randomObjects)) + _guaranteedObjects)} do {
		_position = [_basePos,_objectMinRadius,_objectMaxRadius,1,0,20,0] call BIS_fnc_findSafePos;
		_position = [_position select 0,_position select 1,0];
		_Bodys = ["Body1","Body2"] call BIS_fnc_selectRandom;
		_randomvehicle = ["LADAWreck","BMP2Wreck","UralWreck","HMMWVWreck","T72Wreck"] select round(random 4);
		_chance = random 1;
		if (_chance < 0.9) then {
			_DeadBody = createVehicle [_Bodys, _position, [], 0, "CAN_COLLIDE"];
		} else {
			_wreck = createVehicle [_randomvehicle, _position, [], 0, "CAN_COLLIDE"];
		};
		_z = _z + 1;
	};
};


_placeSearchExpr = "(5 * forest) + (4 * trees) + (3 * meadow) - (20 * houses) - (30 * sea)";
_small = ["Camp1_Small","Camp2_Small","Camp3_Small"];
_medium = []; // "Camp2_Medium","Camp3_Medium","Camp4_Medium","Camp5_Medium"];
_large = [];
_baseArray = ["Camp1_Small","Camp2_Small","Camp3_Small"]; //use this for selection

_placePrecision = 30;
_amount = 0;
_radius = 0;
_lootMinRadius = 0; 
_lootMaxRadius = 0; 
_objectMinRadius = 0; 
_objectMaxRadius = 0; 
_randomObjects = 0; 
_guaranteedObjects = 0; 
_randomLoot = 0; 
_guaranteedLoot = 0;
_baseClass = "";
_campList = [];
_basePos = [];
_markerPos = getMarkerPos "respawn_west";
_b = _qty * 20;

_time = time;
_tmpobject = "Land_HouseV2_05" createVehicleLocal _markerPos;
while {(_b > 0) && (_qty > 0) && (round(time - _time) < 35)} do {
	_baseClass = _baseArray select round(random ((count _baseArray) - 1));
	if (_baseClass in _small) then { _amount = 10; _radius = 100; _lootMinRadius = 8; _lootMaxRadius = 13; _objectMinRadius = 10; _objectMaxRadius = 20; _randomObjects = 8; _guaranteedObjects = 2; _randomLoot = 5; _guaranteedLoot = 1; };
	if (_baseClass in _medium) then { _amount = 25; _radius = 150; _lootMinRadius = 13; _lootMaxRadius = 20; _objectMinRadius = 10; _objectMaxRadius = 20; _randomObjects = 8; _guaranteedObjects = 2; _randomLoot = 5; _guaranteedLoot = 1; };
	if (_baseClass in _large) then { _amount = 40; _radius = 200; _lootMinRadius = 20; _lootMaxRadius = 30; _objectMinRadius = 10; _objectMaxRadius = 20; _randomObjects = 8; _guaranteedObjects = 2; _randomLoot = 5; _guaranteedLoot = 1; };
	{
		if (_x select 1 > 3) then {
			_basePos = _x select 0;
			if (count _basePos >= 2) then {
				_basePos set [2, 0];
				_nextPos = _basePos findEmptyPosition [0, _placePrecision, "Land_HouseV2_05"];
				_basePos = _nextPos;
				if (count _basePos >= 2) then {
					_basePos set [2, 0];
					_tmpobject setPosATL _basePos;
					//sleep 0.003;
					_basePos = _tmpobject modelToWorld (boundingCenter _tmpobject); 
					//sleep 0.003;
					_basePos set [2, 0];
					_tmpobject setPosATL _markerPos;
					//sleep 0.003;
					_basePos = _basePos isFlatEmpty [0, 0, _lootMaxRadius * 0.03, _lootMaxRadius, 0, false, objNull];
					if (count _basePos >= 2) then {
						_basePos set [2, 0];
						if ((0 == count (nearestObjects [_basePos, [], _lootMaxRadius])) AND {(0 == { ((_x select 0) distance _basePos) < _placeMinDistance } count _campList)}) then {
							_campList set [count _campList, [_basePos,_amount,_radius]];
							diag_log(format["%1 found a nice spot at %2 (%3)", __FILE__, _basePos call fa_coor2str,_x select 1]);
							[_basePos, random 360, _baseClass] call spawnComposition;
							[_basePos, _baseClass, _lootMinRadius, _lootMaxRadius, _randomLoot, _guaranteedLoot] call _addLoot;
							[_basePos, _lootMinRadius, _lootMaxRadius, _randomObjects, _guaranteedObjects] call _addWrecks;
							_qty = _qty - 1;
						};
					};
				};
			};
			//sleep 0.01;
		};
	_b = _b - 1;
	} forEach selectBestPlaces [_centerPos, _placeSearchRadius, _placeSearchExpr, _placePrecision, _qty];
};
deleteVehicle _tmpobject;

diag_log(format["%1: found %2 camps spots in %3 sec.", __FILE__, count _campList, round(time - _time)]);

_campList
