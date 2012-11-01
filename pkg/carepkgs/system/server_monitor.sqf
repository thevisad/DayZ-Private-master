waitUntil{!isnil "bis_fnc_init"};

#define PREFIX asff

dayz_versionNo = getText(configFile >> "CfgMods" >> "DayZ" >> "version");
dayz_hiveVersionNo = getNumber(configFile >> "CfgMods" >> "DayZ" >> "hiveVersion");
diag_log("SERVER VERSION: Bliss v4.0");

if ((count playableUnits == 0) and !isDedicated) then {
	isSinglePlayer = true;
	diag_log("SERVER: SINGLEPLAYER DETECTED!");
};
waitUntil{initialized};

//Send the key
_key = format["CHILD:302:%1:", dayZ_instance];
_data = "HiveEXT" callExtension _key;

diag_log("SERVER: Fetching objects...");

//Process result
_result = call compile format ["%1", _data];
_status = _result select 0;

_objList = [];
_objCount = 0;
if (_status == "ObjectStreamStart") then {
	_val = _result select 1;
	for "_i" from 1 to _val do {
		_data = "HiveEXT" callExtension _key;
		_result = call compile format ["%1",_data];

		_status = _result select 0;
		_objList set [count _objList, _result];
		_objCount = _objCount + 1;
	};
	diag_log ("SERVER: Fetched " + str(_objCount) + " objects!");
};

//Spawn objects
_countr = 0;
{
	//Parse individual vehicle row
	_countr = _countr + 1;

	_idKey = 	_x select 1;
	_type =		_x select 2;
	_ownerID = 	_x select 3;
	
	_worldspace = _x select 4;
	_dir = 0;
	_pos = [0,0,0];
	_wsDone = false;
	if (count _worldspace >= 2) then
	{
		_dir = _worldspace select 0;
		if (count (_worldspace select 1) == 3) then {
			_pos = _worldspace select 1;
			_wsDone = true;
		}
	};			
	if (!_wsDone) then {
		if (count _worldspace >= 1) then { _dir = _worldspace select 0; };
		_pos = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;
		if (count _pos < 3) then { _pos = [_pos select 0,_pos select 1,0]; };
		diag_log ("MOVED OBJ: " + str(_idKey) + " of class " + _type + " to pos: " + str(_pos));
	};
	
	_intentory=	_x select 5;
	_hitPoints=	_x select 6;
	_fuel =		_x select 7;
	_damage = 	_x select 8;
	
	if (_damage < 1) then {
		diag_log("Spawned: " + str(_idKey) + " " + _type);
		
		_object = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
		_object setVariable ["lastUpdate",time];

		// Don't set objects for tents to ensure proper inventory updates
		if (!(_object isKindOf "TentStorage")) then {
			_object setVariable ["ObjectID", str(_idKey), true];
		} else {
			_object setVariable ["ObjectUID", _worldspace call dayz_objectUID2, true];
		};

		_object setVariable ["CharacterID", _ownerID, true];
		
		clearWeaponCargoGlobal  _object;
		clearMagazineCargoGlobal  _object;
		
		if (_object isKindOf "TentStorage") then {
			_pos set [2,0];
			_object setpos _pos;
		};
		_object setdir _dir;
		_object setDamage _damage;
		
		if (count _intentory > 0) then {
			//Add weapons
			_objWpnTypes = (_intentory select 0) select 0;
			_objWpnQty = (_intentory select 0) select 1;
			_countr = 0;					
			{
				_isOK = 	isClass(configFile >> "CfgWeapons" >> _x);
				if (_isOK) then {
					_block = 	getNumber(configFile >> "CfgWeapons" >> _x >> "stopThis") == 1;
					if (!_block) then {
						_object addWeaponCargoGlobal [_x,(_objWpnQty select _countr)];
					};
				};
				_countr = _countr + 1;
			} forEach _objWpnTypes; 
			
			//Add Magazines
			_objWpnTypes = (_intentory select 1) select 0;
			_objWpnQty = (_intentory select 1) select 1;
			_countr = 0;
			{
				_isOK = 	isClass(configFile >> "CfgMagazines" >> _x);
				if (_isOK) then {
					_block = 	getNumber(configFile >> "CfgMagazines" >> _x >> "stopThis") == 1;
					if (!_block) then {
						_object addMagazineCargoGlobal [_x,(_objWpnQty select _countr)];
					};
				};
				_countr = _countr + 1;
			} forEach _objWpnTypes;

			//Add Backpacks
			_objWpnTypes = (_intentory select 2) select 0;
			_objWpnQty = (_intentory select 2) select 1;
			_countr = 0;
			{
				_isOK = 	isClass(configFile >> "CfgVehicles" >> _x);
				if (_isOK) then {
					_block = 	getNumber(configFile >> "CfgVehicles" >> _x >> "stopThis") == 1;
					if (!_block) then {
						_object addBackpackCargoGlobal [_x,(_objWpnQty select _countr)];
					};
				};
				_countr = _countr + 1;
			} forEach _objWpnTypes;
		};	
		
		if (_object isKindOf "AllVehicles") then {
			{
				_selection = _x select 0;
				_dam = _x select 1;
				if (_selection in dayZ_explosiveParts and _dam > 0.8) then {_dam = 0.8};
				[_object,_selection,_dam] call object_setFixServer;
			} forEach _hitpoints;
			_object setvelocity [0,0,1];
			_object setFuel _fuel;
			if (getDammage _object == 1) then {
				_position = ([(getPosATL _object),0,100,10,0,500,0] call BIS_fnc_findSafePos);
				if (count _pos < 3) then { _pos = [_pos select 0,_pos select 1,0]; };
				_object setPosATL _position;
			};

			_object addEventHandler ["HandleDamage", { _this call vehicle_handleDamage }];
			_object addEventHandler ["Killed", { _this call vehicle_handleKilled }];
			_object addEventHandler ["GetOut", { _this call vehicle_handleInteract }];
			_object addEventHandler ["GetIn", { _this call vehicle_handleInteract }];
		};

		//Monitor the object
		//_object enableSimulation false;
		dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];
	};
} forEach _objList;

//TIME
_key = "CHILD:307:";
_result = [_key] call server_hiveReadWrite;
_outcome = _result select 0;
if (_outcome == "PASS") then {
	_date = _result select 1; 
	if (isDedicated) then {
		setDate _date;
		dayzSetDate = _date;
		publicVariable "dayzSetDate";
	};

	diag_log("SERVER: Set local time to " + str(_date));
};
	
createCenter civilian;
if (isDedicated) then {
	endLoadingScreen;
};	
hiveInUse = false;

if (isDedicated) then {
	_id = [] execFSM "\z\addons\dayz_server\system\server_cleanup.fsm";
};

allowConnection = true;

for "_x" from 1 to 6 do {
	_id = [] spawn spawn_carePackages;
}; //Spawn care packages

for "_x" from 1 to 5 do {
	_id = [] spawn spawn_heliCrash;
}; //Spawn heli crash
