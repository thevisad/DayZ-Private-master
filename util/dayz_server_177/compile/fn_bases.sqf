/*
       Created exclusively for ArmA2:OA - DayZMod.
       Please request permission to use/alter/distribute from project leader (R4Z0R49).
*/
private ["_centerPos", "_placePrecision", "_placeMaxGradient", "_placeMinDistance", "_placeSearchRadius", "_placeSearchExpr", "_baseClass", "_small", "_medium", "_large", "_amount", "_radius", "_lootMinRadius", "_lootMaxRadius", "_objectMinRadius", "_objectMaxRadius", "_randomObjects", "_guaranteedObjects", "_randomLoot", "_guaranteedLoot", "_qty", "_basePos", "_tmpobject", "_b", "_lootradius", "_addLoot", "_addWrecks", "_campList", "_nextPos"];

_qty = _this select 0;
_centerPos = getMarkerPos (_this select 1);
_placeSearchRadius = _this select 2;
_placeMinDistance = _this select 3;

// add some loot around the camp
_addLoot = {
	private ["_lootTable","_itemTypes","_index","_weights","_cntWeights","_randomLoot",
	"_guaranteedLoot","_itemType","_position","_basePos","_lootMinRadius","_lootMaxRadius",
	"_clutter","_baseClass","_nearby"];

	_basePos = _this select 0;
	_baseClass = _this select 1;
	_lootMinRadius = _this select 2;
	_lootMaxRadius = _this select 3;
	_randomLoot = _this select 4;
	_guaranteedLoot = _this select 5;
	
	_lootTable = ["InfectedCamps"] call BIS_fnc_selectRandom;
	_itemTypes =	[] + getArray (configFile >> "CfgBuildingLoot" >> _lootTable >> "lootType");
	_index = dayz_CBLBase  find _lootTable;
	_weights =		dayz_CBLChances select _index;
	_cntWeights = count _weights;
	
	for "_x" from 1 to (round(random _randomLoot) + _guaranteedLoot) do {
		//create loot
		_index = floor(random _cntWeights);
		_index = _weights select _index;
		_itemType = _itemTypes select _index;
		
		_position = [_basePos,_lootMinRadius,_lootMaxRadius,0,0,0,0] call BIS_fnc_findSafePos;
		_position = [_position select 0,_position select 1,0];
		
		_clutter = createVehicle ["ClutterCutter_small_2_EP1", _position, [], 0, "CAN_COLLIDE"];
		_clutter setPos _position;
		
		[_itemType select 0, _itemType select 1, _position, _lootMaxRadius] call spawn_loot;
	
		diag_log(format["Infected Camps: Loot spawn at '%1:%3' with loot table '%2'", _baseClass, str(_itemType),_position]); 
	
		// ReammoBox is preferred parent class here, as WeaponHolder wouldn't match MedBox0 and other such items.
		_nearby = _basePos nearObjects ["ReammoBox", _lootMaxRadius + 5];
		{
			_x setVariable ["permaLoot",true];
		} forEach _nearby;
	};
};

// add some dead bodies and veh wrecks all around
_addWrecks = {
	private ["_randomObjects","_guaranteedObjects","_position","_basePos","_objectMinRadius","_objectMaxRadius",
	"_Bodys","_randomvehicle","_chance","_DeadBody","_wreck", "_time"];
	_basePos = _this select 0;
	_objectMinRadius = _this select 1;
	_objectMaxRadius = _this select 2;
	_randomObjects = _this select 3;
	_guaranteedObjects = _this select 4;
	
	for "_x" from 1 to (round(random _randomObjects) + _guaranteedObjects) do {
		_position = [_basePos,_objectMinRadius,_objectMaxRadius,0,0,0,0] call BIS_fnc_findSafePos;
		_position = [_position select 0,_position select 1,0];
		_Bodys = ["Body1","Body2"] call BIS_fnc_selectRandom;
		_randomvehicle = ["LADAWreck","BMP2Wreck","UralWreck","HMMWVWreck","T72Wreck"] call BIS_fnc_selectRandom;
		_chance = random 1;
		if (_chance < 0.9) then {
			_DeadBody = _Bodys createVehicle _position;
		} else {
			_wreck = _randomvehicle createVehicle _position;
		};
	};
};


_placeSearchExpr = "(5 * forest) + (4 * trees) + (3 * meadow) - (20 * houses) - (30 * sea)";
_small = ["Camp1_Small","Camp2_Small","Camp3_Small"];
_medium = []; // "Camp2_Medium","Camp3_Medium","Camp4_Medium","Camp5_Medium"];
_large = [];

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

_time = time;
_tmpobject = "Land_HouseV2_05" createVehicleLocal (getMarkerPos "respawn_west"); sleep 0.001; // wait object loading
for [ {_b = _qty * 20}, {_b > 0 AND _qty > 0 }, {_b = _b - 1} ] do {
	_baseClass = (_small + _medium +_large) call BIS_fnc_selectRandom;
	if (_baseClass in _small) then { _amount = 10; _radius = 100; _lootMinRadius = 8; _lootMaxRadius = 13; _objectMinRadius = 10; _objectMaxRadius = 20; _randomObjects = 8; _guaranteedObjects = 2; _randomLoot = 5; _guaranteedLoot = 1; };
	if (_baseClass in _medium) then { _amount = 25; _radius = 150; _lootMinRadius = 13; _lootMaxRadius = 20; _objectMinRadius = 10; _objectMaxRadius = 20; _randomObjects = 8; _guaranteedObjects = 2; _randomLoot = 5; _guaranteedLoot = 1; };
	if (_baseClass in _large) then { _amount = 40; _radius = 200; _lootMinRadius = 20; _lootMaxRadius = 30; _objectMinRadius = 10; _objectMaxRadius = 20; _randomObjects = 8; _guaranteedObjects = 2; _randomLoot = 5; _guaranteedLoot = 1; };
	_lootradius = _radius / 3;
	{
		if (_x select 1 > 3) then {
			_basePos = _x select 0;
			if (count _basePos >= 2) then {
				_basePos set [2, 0];
				_nextPos = _basePos findEmptyPosition [0, _placePrecision, "Land_HouseV2_05"];
				//diag_log(str(_nextPos distance _basePos));
				_basePos = _nextPos;
			};
			if (count _basePos >= 2) then {
				_basePos set [2, 0];
				deleteVehicle _tmpobject; sleep 0.001;
				_tmpobject = "Land_HouseV2_05" createVehicleLocal _basePos; sleep 0.001;
				//diag_log(str(_tmpobject distance _basePos));
				_basePos = _tmpobject modelToWorld (boundingCenter _tmpobject); 
				_basePos set [2, 0];
				deleteVehicle _tmpobject; sleep 0.001;
				_tmpobject = "Land_HouseV2_05" createVehicleLocal (getMarkerPos "respawn_west"); sleep 0.001; // wait object loading
				_basePos = _basePos isFlatEmpty [0, 0, _lootMaxRadius*.03, _lootMaxRadius, 0, false, objNull];
			};
			if (count _basePos >= 2) then {	
				_basePos set [2, 0];
				if ((0 == count (nearestObjects [_basePos, [], _lootMaxRadius])) 
					AND {(0 == { ((_x select 0) distance _basePos) < _placeMinDistance } count _campList)}) then {
					_campList set [count _campList, [_basePos,_amount,_radius]];
					diag_log(format["%1 found a nice spot at %2 (%3)", __FILE__, _basePos call fa_coor2str,_x select 1]);
					[_basePos, random 360, _baseClass] call spawnComposition;
					[_basePos, _baseClass, _lootMinRadius, _lootMaxRadius, _randomLoot, _guaranteedLoot] call _addLoot;
					[_basePos, _lootMinRadius, _lootMaxRadius, _randomObjects, _guaranteedObjects] call _addWrecks;
					_qty = _qty - 1;
					//[_basePos] spawn { sleep 10; { _x setPos (_this select 0);} forEach playableUnits; };
				};
			};
			sleep 0.001;
		};
	} forEach selectBestPlaces [_centerPos, _placeSearchRadius, _placeSearchExpr, _placePrecision, _qty];
};
deleteVehicle _tmpobject;

diag_log(format["%1: found %2 camps spots in %3 sec.", __FILE__, count _campList, round(time - _time)]);

_campList
