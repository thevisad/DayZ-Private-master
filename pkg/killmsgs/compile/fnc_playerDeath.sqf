private ["_victim", "_killer", "_weapon", "_message", "_distance","_loc_message","_victimName","_killerName"];

_victim = _this select 0;
_victimName = name _victim;

_victim removeMPEventHandler ["MPKilled", 0];
_victim removeMPEventHandler ["MPHit", 0];

if (!isPlayer _victim) exitWith 
{
	_victim setVariable["AttackedBy", "nil", true];
	_victim setVariable["AttackedByName", "nil", true];
	_victim setVariable["AttackedByWeapon", "nil", true];
	_victim setVariable["AttackedFromDistance", "nil", true];
};

_killer = _victim getVariable["AttackedBy", "nil"];
_killerName = _victim getVariable["AttackedByName", "nil"];

if (isnil "_killer") then
{
	_victim setVariable["AttackedBy", "nil", true];
	_victim setVariable["AttackedByName", "nil", true];
	_victim setVariable["AttackedByWeapon", "nil", true];
	_victim setVariable["AttackedFromDistance", "nil", true];
};

// when a zombie kills a player _killer, _killerName and _weapon will be "nil"
// we can use this to determine a zombie kill and send a customized message for that. right now no killmsg means it was a zombie.
if (_killerName != "nil") then
{
	_weapon = _victim getVariable["AttackedByWeapon", "nil"];
	_distance = _victim getVariable["AttackedFromDistance", "nil"];

	if (_victimName == _killerName) then 
	{
		_message = format["%1 killed himself",_victimName];
		_loc_message = format["PKILL: %1 killed himself", _victimName];
	}
	else 
	{
		_message = format["%1 was killed by %2 with weapon %3",_victimName, _killerName, _weapon];
		_loc_message = format["PKILL: %1 was killed by %2 with weapon %3 from %4m", _victimName, _killerName, _weapon, _distance];
	};

	diag_log _loc_message;
	[nil, nil, rspawn, [_killer, _message], { (_this select 0) globalChat (_this select 1) }] call RE;
	//[nil, nil, rHINT, _message] call RE;

	// Cleanup
	_victim setVariable["AttackedBy", "nil", true];
	_victim setVariable["AttackedByName", "nil", true];
	_victim setVariable["AttackedByWeapon", "nil", true];
	_victim setVariable["AttackedFromDistance", "nil", true];
};

