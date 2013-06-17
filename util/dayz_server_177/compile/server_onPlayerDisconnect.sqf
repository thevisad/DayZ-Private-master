/*

*/
private ["_playerObj","_myGroup","_id","_playerUID","_playerName","_characterID","_playerIDtoarray","_timeout"];
_playerUID = _this select 0;
_playerName = _this select 1;
_playerObj = nil;
{
	if (getPlayerUID _x == _playerUID) exitWith { _playerObj = _x; };
} forEach 	playableUnits;

if (isNil "_playerObj") exitWith {
	diag_log format["%1: nil player object, _this:%2", __FILE__, _this];
};

_characterID = _playerObj getVariable["characterID", "0"];
_timeout = _playerObj getVariable["combattimeout",0];

if ((_timeout - time) > 0) then {
	diag_log format["Player %1 logged off while in combat (ttl: %2 sec)", _playerName,_timeout];
};

diag_log format["DISCONNECT: %1 (%2) Object: %3, _characterID: %4", _playerName,_playerUID,_playerObj,_characterID];
[_playerUID,_characterID,2] call dayz_recordLogin;

//dayz_disco = dayz_disco - [_playerUID];

if (!isNull _playerObj) then {
//Update Vehicle
	if (vehicle _playerObj != _playerObj) then {
		_playerObj action ["eject", vehicle _playerObj];
	};
	{ [_x,"gear"] call server_updateObject } foreach 
		(nearestObjects [getPosATL _playerObj, ["Car", "Helicopter", "Motorcycle", "Ship", "TentStorage", "StashSmall", "StashMedium"], 10]);
	if (alive _playerObj) then {
		//[_playerObj,(magazines _playerObj),true,(unitBackpack _playerObj)] call server_playerSync;
		[_playerObj,[],true] call server_playerSync;
		_myGroup = group _playerObj;
		deleteVehicle _playerObj;
		deleteGroup _myGroup;
	};
};
