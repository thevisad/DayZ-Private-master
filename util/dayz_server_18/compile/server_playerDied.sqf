#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

private ["_characterID","_minutes","_newObject","_playerID","_key"];
//[unit, weapon, muzzle, mode, ammo, magazine, projectile]

_characterID = 	_this select 0;
_minutes =	_this select 1;
_newObject = 	_this select 2;
_playerID = 	_this select 3;
_playerName = 	name _newObject;

_newObject setVariable["processedDeath",diag_tickTime];
_newObject setVariable ["bodyName", _playerName, true];

if (typeName _minutes == "STRING") then 
{
	_minutes = parseNumber _minutes;
};

if (_characterID != "0") then 
{
	_key = format["CHILD:202:%1:%2:",_characterID,_minutes];
	//diag_log ("HIVE: WRITE: "+ str(_key));
	_key call server_hiveWrite;
} 
else 
{
	deleteVehicle _newObject;
};

#ifdef PLAYER_DEBUG
format ["Player UID#%3 CID#%4 %1 as %5 died at %2", 
	_newObject call fa_plr2str, (getPosATL _newObject) call fa_coor2str,
	getPlayerUID _newObject,_characterID,
	typeOf _newObject
];
#endif

//dead_bodyCleanup set [count dead_bodyCleanup,_newObject];