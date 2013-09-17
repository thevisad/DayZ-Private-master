private["_pos"];
_pos = _this select 0;
#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

{
	[_x, "gear"] call server_updateObject;
#ifdef OBJECT_DEBUG
diag_log(format["Updating nearby object at %1",_pos]);
#endif
} forEach nearestObjects [_pos, ["Car", "Helicopter", "Motorcycle", "Ship", "TentStorage", "StashSmall", "StashMedium"], 10];
