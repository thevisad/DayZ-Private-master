[]execVM "\z\addons\dayz_server\system\s_fps.sqf"; //server monitor FPS (writes each ~181s diag_fps+181s diag_fpsmin*)
#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

dayz_versionNo = 		getText(configFile >> "CfgMods" >> "DayZ" >> "version");
dayz_hiveVersionNo = 	getNumber(configFile >> "CfgMods" >> "DayZ" >> "hiveVersion");
_script = getText(missionConfigFile >> "onPauseScript");

if ((count playableUnits == 0) and !isDedicated) then {
	isSinglePlayer = true;
};

waitUntil{initialized}; //means all the functions are now defined

diag_log "HIVE: Starting";

//Set the Time
	//Send request
	_key = "CHILD:307:";
	_result = _key call server_hiveReadWrite;
	_outcome = _result select 0;
	if(_outcome == "PASS") then {
		_date = _result select 1;
		
		//date setup
		_year = _date select 0;
		_month = _date select 1;
		_day = _date select 2;
		_hour = _date select 3;
		_minute = _date select 4;
		
		//Force full moon nights
		_date = [2012,6,6,_hour,_minute];
		
		if(isDedicated) then {
			//["dayzSetDate",_date] call broadcastRpcCallAll;
			setDate _date;
			dayzSetDate = _date;
			publicVariable "dayzSetDate";
		};
		diag_log ("HIVE: Local Time set to " + str(_date));
	};

	//Stream in objects
	/* STREAM OBJECTS
		//Send the key
		_key = format["CHILD:302:%1:",dayZ_instance];
		_result = _key call server_hiveReadWrite;

		diag_log "HIVE: Request sent";
		
		//Process result
		_status = _result select 0;
		
		_myArray = [];
		if (_status == "ObjectStreamStart") then {
			_val = _result select 1;
			//Stream Objects
			diag_log ("HIVE: Commence Object Streaming...");
			for "_i" from 1 to _val do {
				_result = _key call server_hiveReadWrite;

				_status = _result select 0;
				_myArray set [count _myArray,_result];
				//diag_log ("HIVE: Loop ");
			};
			//diag_log ("HIVE: Streamed " + str(_val) + " objects");
		};
	
		_countr = 0;		
		{
				
			//Parse Array
			_countr = _countr + 1;
		
			_idKey = 	_x select 1;
			_type =		_x select 2;
			_ownerID = 	_x select 3;
			_worldspace = _x select 4;
			_inventory=	_x select 5;
			_hitPoints=	_x select 6;
			_fuel =		_x select 7;
			_damage = 	_x select 8;

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
				_objectPos = [_worldspace select 1 select 0,_worldspace select 1 select 1,0];		
				_pos = [(_objectPos),0,15,1,0,2000,0,[],[_objectPos,[]]] call BIS_fnc_findSafePos;
				if (count _pos < 3) then { _pos = [_pos select 0,_pos select 1,0]; };
				diag_log ("MOVED OBJ: " + str(_idKey) + " of class " + _type + " to pos: " + str(_pos));
			};
			
			if (_damage < 1) then {
				diag_log format["OBJ: %1 - %2", _idKey,_type];
				
				//Create it
				_object = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
				_object setVariable ["lastUpdate",time];
				_object setVariable ["ObjectID", _idKey, true];
				_object setVariable ["CharacterID", _ownerID, true];
				
				clearWeaponCargoGlobal  _object;
				clearMagazineCargoGlobal  _object;
				
				if (_object isKindOf "TentStorage") then {
					_pos set [2,0];
					_object setpos _pos;
					_object addMPEventHandler ["MPKilled",{_this call vehicle_handleServerKilled;}];
				};
				_object setdir _dir;
				_object setDamage _damage;
				
				if (count _inventory > 0) then {
					//Add weapons
					_objWpnTypes = (_inventory select 0) select 0;
					_objWpnQty = (_inventory select 0) select 1;
					_countr = 0;					
					{
						if (_x == "Crossbow") then { _x = "Crossbow_DZ" }; // Convert Crossbow to Crossbow_DZ
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
					_objWpnTypes = (_inventory select 1) select 0;
					_objWpnQty = (_inventory select 1) select 1;
					_countr = 0;
					{
						if (_x == "BoltSteel") then { _x = "WoodenArrow" }; // Convert BoltSteel to WoodenArrow
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
					_objWpnTypes = (_inventory select 2) select 0;
					_objWpnQty = (_inventory select 2) select 1;
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
						[_object,_selection,_dam] call fnc_veh_handleRepair;
					} forEach _hitpoints;
					_object setvelocity [0,0,1];
					_object setFuel _fuel;
					_object call fnc_veh_ResetEH;
					//Updated object position if moved
					if (!_wsDone) then {
						[_object, "position"] call server_updateObject;
					};
				};

				//Monitor the object
				//_object enableSimulation false;
				dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];
			};
		} forEach _myArray;
		
	// # END OF STREAMING #
*/
waituntil{isNil "sm_done"}; // prevent server_monitor be called twice (bug during login of the first player)

#include "\z\addons\dayz_server\compile\fa_hiveMaintenance.hpp"

if (isServer and isNil "sm_done") then {
	private["_i","_hiveResponse","_key","_objectArray","_objectCount"];
	
	for "_i" from 1 to 5 do {
		diag_log "HIVE: trying to get objects";
		_key = format["CHILD:302:%1:", dayZ_instance];
		_hiveResponse = _key call server_hiveReadWrite;  
		if ((((isnil "_hiveResponse") || {(typeName _hiveResponse != "ARRAY")}) || {((typeName (_hiveResponse select 1)) != "SCALAR")}) || {(_hiveResponse select 1 > 2000)}) then {
			diag_log ("HIVE: connection problem... HiveExt response:"+str(_hiveResponse));
			_hiveResponse = ["",0];
		} 
		else {
			diag_log ("HIVE: found "+str(_hiveResponse select 1)+" objects" );
			_i = 99; // break
		};
	};
	
	_objectArray = [];
	if ((_hiveResponse select 0) == "ObjectStreamStart") then {
		_objectCount = _hiveResponse select 1;
		diag_log ("HIVE: Commence Object Streaming...");
		for "_i" from 1 to _objectCount do { 
			_hiveResponse = _key call server_hiveReadWrite;
			_objectArray set [_i - 1, _hiveResponse];
			//diag_log (format["HIVE dbg %1 %2", typeName _hiveResponse, _hiveResponse]);
		};
		diag_log ("HIVE: got " + str(count _objectArray) + " objects");
#ifdef EMPTY_TENTS_CHECK
		// check empty tents, remove some of them
		[_objectArray, EMPTY_TENTS_GLOBAL_LIMIT, EMPTY_TENTS_USER_LIMIT] call fa_removeExtraTents;
#endif
		// check vehicles count
		[_objectArray] call fa_checkVehicles;
	};

	{
		private["_action","_ObjectID","_class","_CharacterID","_worldspace","_inventory", "_hitpoints","_fuel","_damage","_entity","_dir","_point","_res",  "_rawData","_class","_worldspace","_uid", "_selection", "_dam", "_booleans", "_point", "_wantExplosiveParts"];

		_action = _x select 0; // values : "OBJ"=object got from hive  "CREATED"=vehicle just created ...
		_ObjectID = _x select 1;
		_class =	if ((typeName (_x select 2)) == "STRING") then { _x select 2 } else { "Old_bike_TK_CIV_EP1" };
		_CharacterID = _x select 3;			
		_worldspace = if ((typeName (_x select 4)) == "ARRAY") then { _x select 4 } else { [] };
		_inventory=	if ((typeName (_x select 5)) == "ARRAY") then { _x select 5 } else { [] };
		_hitpoints=	if ((typeName (_x select 6)) == "ARRAY") then { _x select 6 } else { [] };
		_fuel =	if ((typeName (_x select 7)) == "SCALAR") then { _x select 7 } else { 0 };
		_damage = if ((typeName (_x select 8)) == "SCALAR") then { _x select 8 } else { 0.9 };  
		_entity = nil;
	
		_dir = floor(random(360));
		_point = getMarkerpos "respawn_west";	
		if (count _worldspace >= 1 && {(typeName (_worldspace select 0)) == "SCALAR"}) then { 
			_dir = _worldspace select 0;
		};
		if (count _worldspace == 2 && {(typeName (_worldspace select 1)) == "ARRAY"}) then { 
			_i = _worldspace select 1;
			if (count _i == 3 &&
				{(typeName (_i select 0)) == "SCALAR"} && 
				{(typeName (_i select 1)) == "SCALAR"} &&
				{(typeName (_i select 2)) == "SCALAR"}) then {
				_point = _i;	
			};
		};
 	
		// if legit vehicle      
		if ((_class isKindOf "AllVehicles") && ((_CharacterID == "0") OR (_CharacterID == "1")) && (_damage < 1)) then {
			//_damage=0.86;//_action="CREATED";
			_point set [2, 0]; // here _point is in ATL format	
#ifdef VEH_MAINTENANCE_ROTTEN_AT_STARTUP
			// rotten randomly the vehicle. Successive damages will lead to a respawn.
			if ((random(VEH_MAINTENANCE_ROTTEN_AT_STARTUP) < 1) AND {(_action == "OBJ")}) then {
				 _damage = VEH_MAINTENANCE_ROTTEN_LOGIC; _action = "DAMAGED"; 
			};
#endif
#ifdef VEH_MAINTENANCE_ADD_MISSING		

			// ask to create a new vehicle if damage is too high
			if (_damage > 0.85 AND (_action != "CREATED")) then { _action = "SPAWNED"; };  
#endif
			// check for no collision with world. Find a suitable place (depending of defined parameters)
			_worldspace = [_class, _dir, _point, _action] call fa_smartlocation;
			if (count _worldspace < 2) then {  // safe position NOT found
				_action = "FAILED"; // don't worry, maybe we will find a nice spot next time :)
			}
			else { // found a spot for respawn
				if ((([_worldspace select 1, _point] call BIS_fnc_distance2D) > 1) 
					AND (_action == "OBJ")) then { _action = "MOVED"; };
				_dir = _worldspace select 0;
				_point = _worldspace select 1;
				_entity = createVehicle [_class, _point, [], 0, 
					if ((_class isKindOf "Air") OR {(_action != "OBJ")}) then {"NONE"} else {"CAN_COLLIDE"}
				]; 
				_entity setVariable ["ObjectID", _ObjectID, true]; // this variable must be set very early
				_entity setVariable ["CharacterID", _CharacterID, true];	
				_entity setVariable ["lastUpdate",time]; // prevent immediate hive write when vehicle parts are set up
				// setPos will be done again just after setDir, see below....
#ifdef VEH_MAINTENANCE_ADD_MISSING		
				if (_damage > 0.85) then { 
					_fuel = VEH_MAINTENANCE_SPAWN_FUEL_LOGIC;
					_hitpoints = [];
					_damage = _hitpoints call fa_setDamagedParts;
		
					_inventory = []; // TODO: rewrite this inventory setup.
					//diag_log (format["VEH MAINTENANCE Creating vehicle Inventory:%1  and  Damaged parts:%2", _inventory, _hitpoints]);
				};
#endif
				_entity setDamage _damage;
				{
					_wantExplosiveParts = _x;
					{
						_selection = _x select 0;
						_dam = _x select 1;
						if (_selection in dayZ_explosiveParts) then {
							if (_wantExplosiveParts) then {
								if (_dam > 0.8) then { _dam = 0.8; };
								[_entity, _selection, _dam] call fnc_veh_handleDam;
							};
						}
						else {
							if (!_wantExplosiveParts) then {
								[_entity, _selection, _dam] call fnc_veh_handleDam;
							};
						};
					} forEach _hitpoints;
				} forEach [false, true]; // we set non explosive part first, then explosive parts
				_entity setvelocity [0,0,1];
				_entity setFuel _fuel;
				_entity call fnc_veh_ResetEH;
			};
#ifdef OBJECT_DEBUG
			diag_log (format["VEHICLE %1 %2 at %3, original damage=%4, effective damage=%6, fuel=%5",
				 _action, _entity call fa_veh2str, (getPosASL _entity) call fa_coor2str, _damage, _fuel, damage _entity]); // , hitpoints:%6, inventory=%7"  , _hitpoints, _inventory 
#endif
		}
		else { // else for object or non legit vehicle
			if (!(_class in SafeObjects )) then {  
				_damage = 1; 
			};
			if (_damage < 1) then {
				// Rule #1: Tents will be always spawned if non empty. 
				// Rule #2: Objects are not spawned if inside/close to building.
				// Rule #3: Rule #1 is higher priority
				_booleans=[];
				_worldspace = [_class, _point, _booleans] call fn_niceSpot;
				if (_booleans select 3) then { // is in building
					if ((_class != "TentStorage") OR {(_inventory call fa_tentEmpty)}) then {
						_action = "FAILED";
						_damage = 5;
#ifdef OBJECT_DEBUG
						diag_log(format["Won't spawn object #%1(%4) in/close to a building, _point:%3, inventory: %5 booleans:%2",_ObjectID, _booleans, _point, _class, _inventory]);
#endif
					};
				};
			};
			if (_damage < 1) then { // create object
#ifdef OBJECTS_FIX_OUTOFMAP
				_worldspace = [_dir, _point] call fa_staywithus;
				_dir =  _worldspace select 0;
				_point =  _worldspace select 1;
#endif
				// for tents: non colliding position
				_entity = createVehicle [_class, _point, [], 0, 
					if (_class=="TentStorage") then {"NONE"} else {"CAN_COLLIDE"}
				];	
				_entity setVariable ["ObjectUID", _ObjectID, true];
				_entity setVariable ["CharacterID", _CharacterID, true];	
				_entity setVariable ["lastUpdate",time];
				_entity setDamage _damage;
	
				if (_class == "TentStorage") then { 
					_entity addMPEventHandler ["MPKilled",{_this call vehicle_handleServerKilled;}]; 
				};
				//diag_log ("DW_DEBUG " + _class + " #" + str(_ObjectID) + " pos=" +  	(_point call fa_coor2str) + ", damage=" + str(_damage)  );
			}
			else { // delete object -- this has been comented out: object are never really deleted from hive
			/*	_key = format["CHILD:306:%1:%2:%3:", _ObjectID, [], 1];
				_rawData = "HiveEXT" callExtension _key;
				_key = format["CHILD:304:%1:",_ObjectID]; // delete by ID (not UID which is handler 310)
				_rawData = "HiveEXT" callExtension _key;*/
#ifdef OBJECT_DEBUG
				diag_log (format["IGNORED %1 oid#%2 cid:%3 ",
					_class, _ObjectID, _CharacterID ]);
#endif
			};
		};
//diag_log(format["VEH MAINTENANCE DEBUG %1 %2", __FILE__, __LINE__]);
			
		// common code (vehicle or not)				
		if (_damage < 1 AND !(isNil ("_entity"))) then {
			_entity setdir _dir;
			_entity setPos _point;
			[_entity, _inventory] call fa_populateCargo;
			
			dayz_serverObjectMonitor set [count dayz_serverObjectMonitor, _entity];
	
			// UPDATE MODIFIED OBJECTS TO THE HIVE 
			if (_action == "CREATED") then {
				// insert className damage characterId  worldSpace inventory  hitPoints  fuel uniqueId  
				_key = format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:", dayZ_instance, 
					_class, _damage , 1, 
					[_dir, _point], 
					[getWeaponCargo _entity, getMagazineCargo _entity ,getBackpackCargo _entity], 
					_hitpoints, _fuel, _ObjectID
				];
				//diag_log (_key);
				_rawData = "HiveEXT" callExtension _key;
			};
			if (_action == "SPAWNED" || _action == "DAMAGED") then {
				// update hitpoint,damage   -- already done by needupdate
				/*_key = format["CHILD:306:%1:%2:%3:", _ObjectID, _hitpoints, _damage];
				_rawData = "HiveEXT" callExtension _key;*/
			};
			if (_action == "SPAWNED") then {
				// update inventory  
				_key = format["CHILD:309:%1:%2:", _ObjectID, 
					[getWeaponCargo _entity, getMagazineCargo _entity, getBackpackCargo _entity]];
				_rawData = "HiveEXT" callExtension _key;
			};
			if (_action == "MOVED" || _action == "SPAWNED") then {
				// update position,fuel in Hive  
				// already done by server_updateObject?
				/*_key = format["CHILD:305:%1:%2:%3:", _ObjectID, [_dir, _point], _fuel];
				_rawData = "HiveEXT" callExtension _key;*/
							//Updated object position if moved
				[_entity, "position"] call server_updateObject;
			};
		}; // not damaged
		sleep 0.01; // yield to connecting players.
	} forEach _objectArray;
	
	createCenter civilian;
	if (isDedicated) then {
		endLoadingScreen;
	};	
	
	if (isDedicated) then {
		_id = [] execFSM "\z\addons\dayz_server\system\server_cleanup.fsm";
	};
	
	allowConnection = true;

	// [_guaranteedLoot, _randomizedLoot, spawnOnStart, _frequency, _variance, _spawnChance, _spawnMarker, _spawnRadius, _spawnFire, _fadeFire]
	[3, 4, 3, (40 * 60), (15 * 60), 0.75, 'center', 4000, true, false] spawn server_spawnCrashSite;
	for "_x" from 1 to 6 do {
		_id = [] spawn spawn_carePackages;
	}; //Spawn care packages
	//Spawn camps
	// quantity, marker, radius, min distance between 2 camps
	Server_InfectedCamps = [3, "center", 4500, 2000] call fn_bases;
	dayzInfectedCamps = Server_InfectedCamps;
	publicVariable "dayzInfectedCamps";

	// antiwallhack
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fa_antiwallhack.sqf";
	
	sm_done = true;
	publicVariable "sm_done";
};