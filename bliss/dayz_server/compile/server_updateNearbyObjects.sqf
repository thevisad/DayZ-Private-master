private["_pos","_objects"];
_pos = _this select 0;

_objects = nearestObjects [_pos, ["Car", "Helicopter", "Motorcycle", "Ship", "TentStorage"], 20];
{
	[_x, "all"] call server_updateObject;
} foreach _objects;
