private["_int","_playerID","_playerObj","_publishTo","_key","_result","_charID","_playerObj","_playerName","_finished","_spawnPos","_spawnDir","_items","_counter","_magazines","_weapons","_group","_backpack","_worldspace","_direction","_newUnit","_score","_position","_isNew","_inventory","_backpack","_medical","_survival","_stats","_state"];
//Set Variables
_playerID = _this select 0;
_playerName = _this select 1;
_playerObj = objNull;
_worldspace = [];

waitUntil{allowConnection};

player sidechat format ["%1 connected...",_playerName];

if (_playerName != "__SERVER__") then {
	//Variables
	_inventory =	[];
	_backpack = 	[];
	_items = 		[];
	_magazines = 	[];
	_weapons = 		[];
	_medicalStats =	[];
	_survival =		[0,0,0];
	_tent =			[];
	_state = 		[];
	_direction =	0;
	_newUnit =		objNull;
	
	//Wait for HIVE to be free
	waitUntil{!hiveInUse};
	hiveInUse = true;
	//Send request
	_key = format["CHILD:101:%1:%2:%3:",_playerID,dayZ_instance,_playerName];
	_result = [_key,true] call fnc_motherrequest;
	//Release HIVE
	hiveInUse = false;
	
	diag_log ("LOGIN: " + str(_result));
	
	//Process request
	_isNew = 		count _result < 4; //_result select 1;
	_charID = 		_result select 2;
	_randomSpot = false;
	_playerObj = objNull;
	
	if (!isSinglePlayer) then {
		//Find the player
		private["_counter"];
		_finished = false;
		_counter = 0;
		while {!_finished} do {
			{
				if(getPlayerUID _x == _playerID) then {
					//This is him
					_playerObj = _x;
					_finished = true;
				};
			} forEach playableUnits;
			_counter = _counter + 1;
			if (_counter > 30) then {
				_finished = true;
			};
			//sleep 1;
		};
	} else {
		_playerObj = player;
	};
	
	if (isNull _playerObj) then {
		diag_log ("LOGIN: Failed to register " + _playerName + " as unable to find their character");
	} else {
		/*
		_int = call compile format ["%1",_playerID];
		if (_int == 2373889) then {
			private["_timeStart"];
			_playerObj setVariable["modelType","Rocket_DZ",true];
			_timeStart = time;
			_exitMe = false;
			while {!_exitMe} do {
				_newUnit = _playerObj getVariable["newModel",objNull];
				if (!(isNull _newUnit)) then {
					_exitMe = true;
				};
				if (isNull _playerObj) then {
					_exitMe = true;
				};		
				sleep 0.01;
			};
			_playerObj = _newUnit;
		};
		*/
		
		diag_log ("LOGIN OBJ: " + str(_playerObj) + " Type: " + (typeOf _playerObj));
		
		if (!_isNew) then {
			//RETURNING CHARACTER		
			//Set position
			_worldspace = 	_result select 3;
			if (count _worldspace > 0) then {
				_direction =	_worldspace select 0;
				_position = 	_worldspace select 1;
				_playerObj setPosATL _position;
				_playerObj setDir _direction;
				//player sidechat "moved to position";
			} else {
				_randomSpot = true;
			};
			_inventory = 	_result select 4;
			_backpack = 	_result select 5;
			_medical =		_result select 6;
			_survival =		_result select 7;
			_stats =		_result select 8;
			_state =		_result select 9;
				
			//set medical values
			if (count _medical > 0) then {
				_playerObj setVariable["USEC_isDead",(_medical select 0),true];
				_playerObj setVariable["NORRN_unconscious", (_medical select 1), true];
				_playerObj setVariable["USEC_infected",(_medical select 2),true];
				_playerObj setVariable["USEC_injured",(_medical select 3),true];
				_playerObj setVariable["USEC_inPain",(_medical select 4),true];
				_playerObj setVariable["USEC_isCardiac",(_medical select 5),true];
				_playerObj setVariable["USEC_lowBlood",(_medical select 6),true];
				_playerObj setVariable["USEC_BloodQty",(_medical select 7),true];
				if (_playerID in dayz_disco) then {
					_playerObj setVariable["NORRN_unconscious",true, true];
					_playerObj setVariable["unconsciousTime",300,true];
				} else {
					_playerObj setVariable["unconsciousTime",(_medical select 10),true];
				};
				
				//Add Wounds
				{
					_playerObj setVariable[_x,true,true];
					[_playerObj,_x,_hit] spawn fnc_usec_damageBleed;
					usecBleed = [_playerObj,_x,0];
					publicVariable "usecBleed";
				} forEach (_medical select 8);
				
				//Add fractures
				_fractures = (_medical select 9);
				_playerObj setVariable ["hit_legs",(_fractures select 0),true];
				_playerObj setVariable ["hit_hands",(_fractures select 1),true];
			};
			
			//register stats
			_playerObj setVariable["zombieKills",(_stats select 0),true];
			_playerObj setVariable["headShots",(_stats select 1),true];
			_playerObj setVariable["humanKills",(_stats select 2),true];
			_playerObj addScore (_stats select 1);
			
			//Save Score
			_score = score _playerObj;
			_playerObj addScore ((_stats select 0) - _score);
			
			//record for Server JIP checks
			_playerObj setVariable["zombieKills_CHK",(_stats select 0)];
			_playerObj setVariable["headShots_CHK",(_stats select 1)];

		} else {
			//Record initial inventory
			_config = (configFile >> "CfgSurvival" >> "Inventory" >> "Default");
			_mags = getArray (_config >> "magazines");
			_wpns = getArray (_config >> "weapons");
			_bcpk = getText (_config >> "backpack");
			_randomSpot = true;
			
			//Save initial loadout
			//register stats
			_playerObj setVariable["zombieKills",0,true];
			_playerObj setVariable["humanKills",0,true];		
			_playerObj setVariable["headShots",0,true];
			
			//record for Server JIP checks
			_playerObj setVariable["zombieKills_CHK",0];
			_playerObj setVariable["humanKills_CHK",0,true];	
			_playerObj setVariable["headShots_CHK",0];
			
			//Reset Fractures
			_playerObj setVariable ["hit_legs",0,true];
			_playerObj setVariable ["hit_hands",0,true];
			_playerObj setVariable ["USEC_injured",false,true];
			_playerObj setVariable ["USEC_inPain",false,true];
			
			//Wait for HIVE to be free
			waitUntil{!hiveInUse};
			hiveInUse = true;
			//Send request
			_key = format["CHILD:203:%1:%2:%3:",_charID,[_wpns,_mags],[_bcpk,[],[]]];
			_result = [_key,false] call fnc_motherrequest;
			//Release HIVE
			hiveInUse = false;
		};
		
		diag_log ("LOGIN LOADED: " + str(_playerObj) + " Type: " + (typeOf _playerObj));
		
		if (_randomSpot) then {
			if (!isDedicated) then {
				endLoadingScreen;
			};
			
			//spawn into random
			_findSpot = true;
			while {_findSpot} do {
				_mkr = "spawn" + str(round(random 4));
				_position = ([(getMarkerPos _mkr),0,1500,10,0,2000,1] call BIS_fnc_findSafePos);
				_isNear = count (_position nearEntities ["Man",200]) == 0;
				_isZero = ((_position select 0) == 0) and ((_position select 1) == 0);
				if (_isNear and !_isZero) then {_findSpot = false};
			};
			_position = [_position select 0,_position select 1,0];
			_playerObj setPosATL _position;
		};
		
		//record player pos locally for server checking
		_playerObj setVariable["lastPos",getPosATL _playerObj];
		//record time started
		_playerObj setVariable ["lastTime",time];
		
		diag_log ("LOGIN PUBLISHING: " + str(_playerObj) + " Type: " + (typeOf _playerObj));

		//Server publishes variable to clients and WAITS
		_playerObj setVariable ["publish",[_charID,_inventory,_backpack,_survival,_isNew,_state,dayz_versionNo],true];
		_counter = 0;

		while {(!(_playerObj getVariable ["characterID","0"] != "0") and (_counter < 10))} do {
			_playerObj setVariable ["publish",[_charID,_inventory,_backpack,_survival,_isNew,_state],true];
			diag_log ("LOGIN ATTEMPT: " + str(_counter) + " : " + str(_playerObj) + " Type: " + (typeOf _playerObj));
			_counter = _counter + 1;
			//sleep 1;
		};	
		
		if (_counter < 10) then {
			//announce	
			diag_log format["Registered CharacterID %1 - %2",_charID,_playerName];
		};

	};
	//Wait and resend until sure the player has actioned it (or they disconnected)
};