[]execVM "\z\addons\dayz_server\system\s_fps.sqf"; //server monitor FPS (writes each ~181s diag_fps+181s diag_fpsmin*)

dayz_versionNo = 		getText(configFile >> "CfgMods" >> "DayZ" >> "version");
dayz_hiveVersionNo = 	getNumber(configFile >> "CfgMods" >> "DayZ" >> "hiveVersion");

if ((count playableUnits == 0) and !isDedicated) then {
	isSinglePlayer = true;
};

waitUntil{initialized};

diag_log format ["INFORMATION: Server Is Running DayZ+ %1 And Hive %2", dayz_versionNo, dayz_hiveVersionNo];
diag_log "HIVE: Starting";

		_key = format["CHILD:302:%1:",dayZ_instance];
		_data = "HiveEXT" callExtension _key;

		diag_log "HIVE: Request sent";
		
		_result = call compile format ["%1",_data];
		_status = _result select 0;
		
		_myArray = [];
		if (_status == "ObjectStreamStart") then {
			_val = _result select 1;
			diag_log ("HIVE: Steaming Objects");
			for "_i" from 1 to _val do {
				_data = "HiveEXT" callExtension _key;
				_result = call compile format ["%1",_data];
				_status = _result select 0;
				_myArray set [count _myArray,_result];
			};
		};
	
		_countr = 0;		
		{
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
				diag_log ("MOVED OBJECT: " + str(_idKey) + " of class " + _type + " to pos: " + str(_pos));
			};

			_intentory=	_x select 5;
			_hitPoints=	_x select 6;
			_fuel =		_x select 7;
			_damage = 	_x select 8;
			
			if (_damage < 1) then {
				diag_log format["STREAMED OBJECT: %1 - %2", _idKey,_type];
				_object = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
				_object setVariable ["lastUpdate",time];
				_object setVariable ["ObjectID", _idKey, true];
				_object setVariable ["CharacterID", _ownerID, true];
				
				clearWeaponCargoGlobal  _object;
				clearMagazineCargoGlobal  _object;
				
				_object setdir _dir;
				_object setDamage _damage;
				
				if (count _intentory > 0) then {
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
						_object setPosATL _position;
					};
					_object call fnc_vehicleEventHandler;			
				};

				dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];
			};
		} forEach _myArray;

	_key = "CHILD:307:";
	_result = [_key] call server_hiveReadWrite;
	_outcome = _result select 0;
	if(_outcome == "PASS") then {
		_date = _result select 1; 
		if(isDedicated) then {
			setDate _date;
			dayzSetDate = _date;
			publicVariable "dayzSetDate";
		};

		diag_log ("HIVE: Local Time set to " + str(_date));
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

for "_x" from 1 to 3 do {
	_id = [] call spawn_UH1YCrashSite;
};

for "_x" from 1 to 2 do {
	_id = [] call spawn_UH60CrashSite;
};