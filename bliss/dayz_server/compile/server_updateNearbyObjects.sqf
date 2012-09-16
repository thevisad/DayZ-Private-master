private["_pos","_objects"];
_pos = _this select 0;

_objects = nearestObjects [_pos, ["Car", "Helicopter", "Motorcycle", "Ship", "TentStorage"], 10];
{
	[_x, "gear"] call server_updateObject;
	[_x, "position"] call server_updateObject;
} foreach _objects;
