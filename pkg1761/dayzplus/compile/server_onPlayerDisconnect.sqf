private ["_object","_myGroup","_id","_playerID","_playerName","_characterID","_playerIDtoarray","_timeout"];
_playerID = _this select 0;
_playerName = _this select 1;
_object = call compile format["player%1",_playerID];
_characterID =	_object getVariable ["characterID","0"];
_isInCombat = _object getVariable ["isincombat",0];
_playerIDtoarray = [];
_playerIDtoarray = toArray _playerID;

if (vehicle _object != _object) then {
	_object action ["eject", vehicle _object];
};

if (59 in _playerIDtoarray) exitWith { 	diag_log ("Exited"); };

if (_isInCombat > 0) then {
	diag_log format ["COMBATLOG: %1 (%2) Combat Logged", _playerName, _playerID];
	dayz_combatLog = _playerName;
	publicVariable "dayz_combatLog";
} else {
	diag_log format ["DISCONNECT: %1 (%2) Disconnected", _playerName, _playerID];
};

dayz_disco = dayz_disco - [_playerID];
if (!isNull _object) then {
	{ [_x,"gear"] call server_updateObject } foreach 
		(nearestObjects [getPosATL _object, ["Car", "Helicopter", "Motorcycle", "Ship", "TentStorage"], 10]);
	if (alive _object) then {
		[_object,[],true] call server_playerSync;
		_id = [_playerID,_characterID,2] spawn dayz_recordLogin;
		_myGroup = group _object;
		deleteVehicle _object;
		deleteGroup _myGroup;
	};
};