private ["_characterID","_temp","_currentWpn","_magazines","_force","_isNewPos","_humanity","_isNewGear","_currentModel","_modelChk","_playerPos","_playerGear","_playerBackp","_backpack","_killsB","_killsH","_medical","_isNewMed","_character","_timeSince","_charPos","_isInVehicle","_distanceFoot","_lastPos","_kills","_headShots","_timeGross","_timeLeft","_onLadder","_isTerminal","_currentAnim","_muzzles","_array","_key","_lastTime","_config","_currentState","_pos"];

if ( typeName(_this) == "OBJECT" ) then {
	_this = [_this,[],true];
};

_character = 	_this select 0;
_magazines =	_this select 1;
_force =	_this select 2;
_force =	true;
_characterID =	_character getVariable ["characterID","0"];
_charPos = 		getPosATL _character;
_isInVehicle = 	vehicle _character != _character;
_timeSince = 	0;
_humanity =		0;

if (_character isKindOf "Animal") exitWith {
	diag_log ("ERROR: Cannot Sync Character " + (name _character) + " is an Animal class");
};

if (isnil "_characterID") exitWith {
	diag_log ("ERROR: Cannot Sync Character " + (name _character) + " has nil characterID");	
};

if (_characterID == "0") exitWith {
	diag_log ("ERROR: Cannot Sync Character " + (name _character) + " as no characterID");
};

private["_debug","_distance"];
_debug = getMarkerpos "respawn_west";
_distance = _debug distance _charPos;
if (_distance < 2000) exitWith { 
	diag_log format["ERROR: server_playerSync: Cannot Sync Player %1 [%2]. Position in debug! %3",name _character,_characterID,_charPos];
};

_isNewMed =		_character getVariable["medForceUpdate",false];
_isNewPos =		_character getVariable["posForceUpdate",false];
_isNewGear =	(count _magazines) > 0;

if (_characterID != "0") then {
	_playerPos =	[];
	_playerGear =	[];
	_playerBackp =	[];
	_medical =		[];
	_distanceFoot =	0;

	if (_isNewPos or _force) then {
		if (((_charPos select 0) == 0) and ((_charPos select 1) == 0)) then {
		} else {
			_playerPos = 	[round(direction _character),_charPos];
			_lastPos = 		_character getVariable["lastPos",_charPos];
			if (count _lastPos > 2 and count _charPos > 2) then {
				if (!_isInVehicle) then {
					_distanceFoot = round(_charPos distance _lastPos);
				};
				_character setVariable["lastPos",_charPos];
			};
			if (count _charPos < 3) then {
				_playerPos =	[];
			};
		};
		_character setVariable ["posForceUpdate",false,true];
	};
	if (_isNewGear) then {
		_playerGear = [weapons _character,_magazines];
		_backpack = unitBackpack _character;
		_playerBackp = [typeOf _backpack,getWeaponCargo _backpack,getMagazineCargo _backpack];
	};
	if (_isNewMed or _force) then {
		if (!(_character getVariable["USEC_isDead",false])) then {
			_medical = _character call player_sumMedical;
		};
		_character setVariable ["medForceUpdate",false,true];
	};
	
	if (_characterID != "0") then {		
		_kills = 		["zombieKills",_character] call server_getDiff;
		_killsB = 		["banditKills",_character] call server_getDiff;
		_killsH = 		["humanKills",_character] call server_getDiff;
		_headShots = 	["headShots",_character] call server_getDiff;
		_humanity = 	["humanity",_character] call server_getDiff2;
		_character addScore _kills;		
		_lastTime = 	_character getVariable["lastTime",time];
		_timeGross = 	(time - _lastTime);
		_timeSince = 	floor(_timeGross / 60);
		_timeLeft =		(_timeGross - (_timeSince * 60));
		_currentWpn = 	currentMuzzle _character;
		_currentAnim =	animationState _character;
		_config = 		configFile >> "CfgMovesMaleSdr" >> "States" >> _currentAnim;
		_onLadder =		(getNumber (_config >> "onLadder")) == 1;
		_isTerminal = 	(getNumber (_config >> "terminal")) == 1;
		_currentModel = typeOf _character;
		_modelChk = 	_character getVariable ["model_CHK",""];
		if (_currentModel == _modelChk) then {
			_currentModel = "";
		} else {
			_currentModel = str(_currentModel);
			_character setVariable ["model_CHK",typeOf _character];
		};
		
		if (_onLadder or _isInVehicle or _isTerminal) then {
			_currentAnim = "";
			if ((count _playerPos > 0) and !_isTerminal) then {
				_charPos set [2,0];
				_playerPos set[1,_charPos];					
			};
		};
		if (_isInVehicle) then {
			_currentWpn = "";
		} else {
			if ( typeName(_currentWpn) == "STRING" ) then {
			_muzzles = getArray(configFile >> "cfgWeapons" >> _currentWpn >> "muzzles");
			if (count _muzzles > 1) then {
				_currentWpn = currentMuzzle _character;
			};	
			} else {
			_currentWpn = "";
				};
		};
		_temp = round(_character getVariable ["temperature",100]);
		_currentState = [_currentWpn,_currentAnim,_temp];
		if (count _playerPos > 0) then {
			_array = [];
			{
				if (_x > -20000 and _x < 20000) then {
					_array set [count _array,_x];
				};
			} forEach (_playerPos select 1);
			_playerPos set [1,_array];
		};
		if (!isNull _character) then {
			if (alive _character) then {
				_key = format["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:",_characterID,_playerPos,_playerGear,_playerBackp,_medical,false,false,_kills,_headShots,_distanceFoot,_timeSince,_currentState,_killsH,_killsB,_currentModel,_humanity];
				_key call server_hiveWrite;
			};
		};
		
		if (vehicle _character != _character) then {
			[vehicle _character, "position"] call server_updateObject;
		};
		
		_pos = _this select 0;
		{
			[_x, "gear"] call server_updateObject;
		} forEach nearestObjects [_pos, ["Car", "Helicopter", "Motorcycle", "Ship", "TentStorage"], 10];

		if (_timeSince > 0) then {
			_character setVariable ["lastTime",(time - _timeLeft)];
		};
	};
};