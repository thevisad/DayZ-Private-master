private["_hasDel","_serial","_object","_updates","_myGroup","_nearVeh"];
_playerID = _this select 0;
_playerName = _this select 1;
_object = call compile format["player%1",_playerID];
_characterID =	_object getVariable ["characterID","0"];

if (vehicle _object != _object) then {
	_object action ["eject", vehicle _object];
};

diag_log ("DISCONNECT START (i): " + _playerName + " (" + str(_playerID) + ") Object: " + str(_object) );

if (_characterID != "0") then {
	if (alive _object) then {
		[_playerID,_characterID,typeof _object,_object] spawn player_discoMorph;
	};
	[_object,[],true] call server_playerSync;
	_id = [_playerID, _characterID, 2] spawn dayz_recordLogin;
};

if (!isNull _object) then {
	_charPos = getPosATL _object;
	[_charPos] call server_updateNearbyObjects;

	if (alive _object) then {
		_myGroup = group _object;
		deleteVehicle _object;
		deleteGroup _myGroup;
	};
};
