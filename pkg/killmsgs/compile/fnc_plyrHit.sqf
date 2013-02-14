private ["_victim", "_attacker","_weapon","_distance","_victimPlayerID","_attakerPlayerID"];
_victim = _this select 0;
_attacker = _this select 1;

if (!isPlayer _victim || !isPlayer _attacker) exitWith {};
if ((name _victim) == (name _attacker)) exitWith {};

_weapon = weaponState _attacker;
if (_weapon select 0 == "Throw") then 
{
	_weapon = _weapon select 3;
}
else
{
	_weapon = _weapon select 0;
};

_distance = _victim distance _attacker;

_victimPlayerID = getPlayerUID _victim;
_attakerPlayerID = getPlayerUID _attacker;

diag_log format["PHIT: %1 (%5) was hit by %2 (%6) with %3 from %4m", _victim, _attacker, _weapon, _distance, _victimPlayerID, _attakerPlayerID];

_victim setVariable["AttackedBy", _attacker, true];
_victim setVariable["AttackedByName", (name _attacker), true];
//_victim setVariable["AttackedByWeapon", (currentWeapon _attacker), true];
_victim setVariable["AttackedByWeapon", _weapon, true];
_victim setVariable["AttackedFromDistance", _distance, true];

