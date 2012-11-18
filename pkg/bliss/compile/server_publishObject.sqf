private ["_class","_uid","_charID","_object","_worldspace","_key"];
//[dayz_characterID,_tent,[_dir,_location],"TentStorage"]
_charID =		_this select 0;
_object = 		_this select 1;
_worldspace = 	_this select 2;
_class = 		_this select 3;

if (!(_object isKindOf "Building")) exitWith {
	deleteVehicle _object;
};

//diag_log ("PUBLISH: Attempt " + str(_object));

//get UID
_uid = _worldspace call dayz_objectUID2;

//Send request
_key = format["CHILD:308:%1:%2:%3:%4:%5:", dayz_instance, _class, _charID, _worldspace, _uid];
//diag_log ("HIVE: WRITE: "+ str(_key));
_key call server_hiveWrite;

_object setVariable ["ObjectUID", _uid, true];

dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];

//diag_log ("PUBLISH: Created " + (_class) + " with ID " + _uid);
