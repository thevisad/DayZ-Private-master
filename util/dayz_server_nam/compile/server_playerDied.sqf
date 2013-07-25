#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

private ["_characterID","_minutes","_newObject","_playerID","_key"];
//[unit, weapon, muzzle, mode, ammo, magazine, projectile]

_characterID = 	_this select 0;
_minutes =	_this select 1;
_newObject = 	_this select 2;
_playerID = 	_this select 3;
_playerName = 	name _newObject;

//dayz_disco = dayz_disco - [_playerID];
_newObject setVariable["processedDeath",time];
_newObject setVariable ["bodyName", _playerName, true];

/*
diag_log ("DW_DEBUG: (isnil _characterID): " + str(isnil "_characterID"));
if (isnil "_characterID") then {
diag_log ("DW_DEBUG: _newObject: " + str(_newObject));	
	};
*/

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

/*
_eh = [_newObject] spawn {
	_body = _this select 0;
	_method = _body getVariable["deathType","unknown"];
	_name = _body getVariable["bodyName","unknown"];
	waitUntil{!isPlayer _body;sleep 1};
	_body setVariable["deathType",_method,true];
	_body setVariable["bodyName",_name,true];
	diag_log ("PDEATH: Player Left Body " + _name);
};
*/
//dead_bodyCleanup set [count dead_bodyCleanup,_newObject];