private ["_object","_myGroup","_id","_playerID","_playerName","_characterID","_playerIDtoarray","_timeout"];
_playerID = _this select 0;
_playerName = _this select 1;
_object = call compile format["player%1",_playerID];
_characterID =	_object getVariable ["characterID","0"];
_timeout = _object getVariable["combattimeout",0];

_playerIDtoarray = [];
_playerIDtoarray = toArray _playerID;

if (vehicle _object != _object) then {
	_object action ["eject", vehicle _object];
};

if (59 in _playerIDtoarray) exitWith { 	diag_log ("Exited"); };

if ((_timeout - time) > 0) then {
	_timeout = _object getVariable["combattimeout",0];
	diag_log format["COMBAT LOGGED: %1 (%2)", _playerName,_timeout];
};

diag_log format["DISCONNECT: %1 (%2) Object: %3, _characterID: %4", _playerName,_playerID,_object,_characterID];

dayz_disco = dayz_disco - [_playerID];
if (!isNull _object) then {
	_charPos = getPosATL _object;
	[_charPos] call server_updateNearbyObjects;

	if (alive _object) then {
		[_object, (magazines _object), true] call server_playerSync;
		_myGroup = group _object;
		deleteVehicle _object;
		deleteGroup _myGroup;
	};

	[_playerID,_characterID,2] call dayz_recordLogin;
};
