private["_pos","_objects"];
_pos = _this select 0;

{
	[_x, "all"] call server_updateObject;
	if (_x isKindOf "AllVehicles") then {
		[_x, "damage", true] call server_updateObject;
	};
} forEach nearestObjects [_pos, ["Car", "Helicopter", "Motorcycle", "Ship", "Animals", "TentStorage"], 10];
