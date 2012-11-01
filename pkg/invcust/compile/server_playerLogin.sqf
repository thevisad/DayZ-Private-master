private["_int","_newModel","_doLoop","_wait","_hiveVer","_isHiveOk","_playerID","_playerObj","_randomSpot","_publishTo","_primary","_secondary","_key","_result","_charID","_playerObj","_playerName","_finished","_spawnPos","_spawnDir","_items","_counter","_magazines","_weapons","_group","_backpack","_worldspace","_direction","_newUnit","_score","_position","_isNew","_inventory","_backpack","_medical","_survival","_stats","_state"];
//Set Variables
_playerID = _this select 0;
_playerObj = _this select 1;
_playerName = name _playerObj;
_worldspace = [];

if (count _this > 2) then {
	dayz_players = dayz_players - [_this select 2];
};

waitUntil{allowConnection};

//Variables
_inventory =	[];
_backpack = 	[];
_items = 		[];
_magazines = 	[];
_weapons = 		[];
_medicalStats =	[];
_survival =		[0,0,0];
_tent =			[];
_state = 		[];
_direction =	0;
_model =		"";
_newUnit =		objNull;

if (_playerID == "") then {
	_playerID = getPlayerUID _playerObj;
};

if ((_playerID == "") or (isNil "_playerID")) exitWith {
	diag_log ("LOGIN FAILED: Player [" + _playerName + "] has no login ID");
};

endLoadingScreen;
diag_log ("LOGIN ATTEMPT: " + str(_playerID) + " " + _playerName);

_key = format["CHILD:101:%1:%2:%3:",_playerID,dayZ_instance,_playerName];
_primary = [_key,false,dayZ_hivePipeAuth] call server_hiveReadWrite;

if (isNull _playerObj or !isPlayer _playerObj) exitWith {
	diag_log ("LOGIN RESULT: Exiting, player object null: " + str(_playerObj));
};

//Process request
_newPlayer  = _primary select 1;
_isNew      = count _primary < 6;
_charID     = _primary select 2;
_randomSpot = false;
_hiveVer    = 0;

//Set character variables
_inventory = _primary select 4;
_backpack  = _primary select 5;
_survival  = _primary select 6;
_model     = _primary select 7;
_hiveVer   = _primary select 8;
	
if (!(_model in ["SurvivorW2_DZ","Survivor2_DZ","Survivor3_DZ","Sniper1_DZ","Soldier1_DZ","Camo1_DZ","Bandit1_DZ","Rocket_DZ"])) then {
	_model = "Survivor2_DZ";
};

diag_log ("LOGIN LOADED: " + str(_playerObj) + " Type: " + (typeOf _playerObj));

_key = format["CHILD:999:select replace(cl.`inventory`, '""', '""""') inventory, replace(cl.`backpack`, '""', '""""') backpack, replace(coalesce('Survivor2_DZ', cl.`model`), '""', '""""') model from `cust_loadout` cl join `cust_loadout_profile` clp on clp.`cust_loadout_id` = cl.`id` join `profile` p on clp.`unique_id` = p.`unique_id` left join (select distinct `unique_id` from `survivor` where `is_dead` = 0 and last_updated < now() - interval 2 minute) x on x.`unique_id` = p.`unique_id` where x.`unique_id` is null and clp.`unique_id` = ?:[%1]:",_playerID];
_data = "HiveEXT" callExtension _key;

//Process result
_result = call compile format ["%1", _data];
_status = _result select 0;

if (_status == "CustomStreamStart") then {
	if ((_result select 1) > 0) then {
		_data = "HiveEXT" callExtension _key;
		_result = call compile format ["%1", _data];
		_inventory = call compile (_result select 0);
		_backpack = call compile (_result select 1);
		_model = call compile (_result select 2);
	};
};

_isHiveOk = false;
if (_hiveVer >= dayz_hiveVersionNo) then {
	_isHiveOk = true;
};

_clientID = owner _playerObj;
dayzPlayerLogin = [_charID,_inventory,_backpack,_survival,_isNew,dayz_versionNo,_model,_isHiveOk,_newPlayer];
_clientID publicVariableClient "dayzPlayerLogin";

//_playerObj enableSimulation false;