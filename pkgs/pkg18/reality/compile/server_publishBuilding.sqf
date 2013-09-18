private ["_class","_uid","_charID","_building","_worldspace","_key","_playerUID"];
//[dayz_characterID,_tent,[_dir,_location],"TentStorage"]
_charID =		_this select 0;
_building = 		_this select 1;
_worldspace = 	_this select 2;
_class = 		_this select 3;
//_squad = 		_this select 4;

_squad = 0;
_playerUID = 0;
#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"
_combination = 0;
if (!(_building isKindOf "Building")) exitWith {
	deleteVehicle _building;
};

//Commenting this out for the time being to identify potential issues.
// Uncomment if every buildable has been added to DZE_allowedObjects array.
//_allowed = [_building, "Server"] call check_publishbuilding;
//if (!_allowed) exitWith { };

//get UID
_uid = _worldspace call dayz_objectUID2;

//Send request

_combination = floor(random 899) + 100;
_key = format["CHILD:400:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance,_class,_uid,_worldspace, [],[],_charID,_squad ,_combination];
//_key = format["CHILD:400:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance,_uid,_class,_charID,_worldspace, [],[],_squad ,_combination];
//diag_log ("HIVE: WRITE: "+ str(_key));
_key call server_hiveWrite;

_building setVariable ["ObjectUID", _uid,true];

if (_building isKindOf "TentStorage") then {
	_building addMPEventHandler ["MPKilled",{_this call vehicle_handleServerKilled;}];
};

dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_building];

#ifdef OBJECT_DEBUG
diag_log ("USPB: Created " + (_class) + " with ID " + _uid + " and a combination of " + str(_combination) );
#endif
