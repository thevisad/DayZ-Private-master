private["_botActive","_int","_newModel","_doLoop","_wait","_hiveVer","_isHiveOk","_playerID","_playerObj","_randomSpot","_publishTo","_primary","_secondary","_key","_result","_charID","_playerObj","_playerName","_finished","_spawnPos","_spawnDir","_items","_counter","_magazines","_weapons","_group","_backpack","_worldspace","_direction","_newUnit","_score","_position","_isNew","_inventory","_backpack","_medical","_survival","_stats","_state"];
//Set Variables

diag_log ("STARTING LOGIN: " + str(_this));

_playerID = _this select 0;
_playerObj = _this select 1;
_playerName = name _playerObj;
_worldspace = [];

if (_playerName == '__SERVER__' || _playerID == '' || local player) exitWith {};

if (count _this > 2) then {
	dayz_players = dayz_players - [_this select 2];
};

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
_botActive = false;

if (_playerID == "") then {
	_playerID = getPlayerUID _playerObj;
};

if ((_playerID == "") or (isNil "_playerID")) exitWith {
	diag_log ("LOGIN FAILED: Player [" + _playerName + "] has no login ID");
};

//??? endLoadingScreen;
diag_log ("LOGIN ATTEMPT: " + str(_playerID) + " " + _playerName);

//Do Connection Attempt
_doLoop = 0;
while {_doLoop < 5} do {
	_key = format["CHILD:101:%1:%2:%3:",_playerID,dayZ_instance,_playerName];
	_primary = _key call server_hiveReadWrite;
	if (count _primary > 0) then {
		if ((_primary select 0) != "ERROR") then {
			_doLoop = 9;
		};
	};
	_doLoop = _doLoop + 1;
};

if (isNull _playerObj or !isPlayer _playerObj) exitWith {
	diag_log ("LOGIN RESULT: Exiting, player object null: " + str(_playerObj));
};

if ((_primary select 0) == "ERROR") exitWith {	
    diag_log format ["LOGIN RESULT: Exiting, failed to load _primary: %1 for player: %2 ",_primary,_playerID];
};

//Process request
_newPlayer = 	_primary select 1;
_isNew = 		count _primary < 6; //_result select 1;
_charID = 		_primary select 2;
_randomSpot = false;

//diag_log ("LOGIN RESULT: " + str(_primary));
/* PROCESS */
_hiveVer = 0;

if (!_isNew) then {
	//RETURNING CHARACTER		
	_inventory = 	_primary select 4;
	_backpack = 	_primary select 5;
	_survival =		_primary select 6;
	_model =		_primary select 7;
	_hiveVer =		_primary select 8;

// There is also "Hero2_DZC_TEST" and Bandit2_DZC_TEST which seems not to be used for now
	if (!(_model in ["Soldier1_SL_DZC","Soldier2_SL_DZC","Soldier3_SL_DZC","Soldier1_AT_DZC","Soldier2_AT_DZC","Soldier3_AT_DZC","Soldier1_GL_DZC","Soldier2_GL_DZC","Soldier3_GL_DZC","Soldier1_STD_DZC","Soldier2_STD_DZC","Soldier3_STD_DZC","Camo1_DZC","Camo2_DZC","Camo3_DZC","Doctor_DZC","Civ_Soldier_DZC","Cameraman_DZC","EuroMan01_DZC","EuroMan02_DZC","Storm_Trooper1_DZC","Storm_Trooper2_DZC","Storm_Trooper3_DZC","Storm_Trooper4_DZC","PrivateSec1_DZC","PrivateSec2_DZC","PrivateSec3_DZC","Asano_DZC","Hazmat_Black_DZC","HazmatVest_Black_DZC","Hazmat_Red_DZC","HazmatVest_Red_DZC","Hazmat_Yellow_DZC","HazmatVest_Yellow_DZC","Hazmat_Olive_DZC","HazmatVest_Olive_DZC","CIV_Pilot1_DZC","US_Pilot1_DZC","CZ_Pilot1_DZC","CZ_Pilot2_DZC","CZ_Pilot3_DZC","BAF_Pilot1_DZC","BAF_Pilot2_DZC","BAF_Pilot3_DZC","CZ_Heavy1_DZC","CZ_Heavy2_DZC","CZ_Heavy3_DZC","BAF_Heavy1_DZC","BAF_Heavy2_DZC","BAF_Heavy3_DZC","US_Heavy1_DZC","US_Heavy2_DZC","BAF_Officer1_DZC","BAF_Officer2_DZC","BAF_Officer3_DZC","CZ_Officer1_DZC","CZ_Officer2_DZC","CZ_Officer3_DZC","GER_Officer1_DZC","Soldier1_DZC","Soldier2_DZC","Soldier3_DZC","Soldier1_SF_DZC","Soldier2_SF_DZC","Soldier3_SF_DZC","Snow_Trooper1_DZC","Snow_Trooper2_DZC","Sniper1_DZC","Sniper2_DZC","Sniper3_DZC","Clan_Officer1_DZC","Clan_Officer2_DZC","Clan_Officer3_DZC","Clan_Delta1","Clan_Delta2","Clan_Delta3_DZC","Clan_UN_Helmet_DZC","Clan_UN_Cap_DZC","Clan_GER_DZC","Clan_GER_Hvy_DZC","Clan_Terror_DZC","Clan_Terror2_DZC","Clan_nobackpack_INS1_DZC","Clan_nobackpack_INS2_DZC","Clan_nobackpack_INS3_DZC","Clan_nobackpack_suit_DZC","Survivor1_DZ","Survivor2_DZ","SurvivorW2_DZ","Hero1_DZC","Bandit1_DZC","BanditW1_DZC"])) then {
		_model = "Survivor2_DZ";
	};
} else {


	_model =		_primary select 3;
	_hiveVer =		_primary select 4;
	if (isNil "_model") then {
		_model = "Survivor2_DZ";
	} else {
		if (_model == "") then {
			_model = "Survivor2_DZ";
		};
	};
		_key = format["CHILD:999:select replace(cl.`inventory`, '""', '""""') inventory, replace(cl.`backpack`, '""', '""""') backpack, replace(coalesce(cl.`model`, 'Survivor2_DZ'), '""', '""""') model from `cust_loadout` cl join `cust_loadout_profile` clp on clp.`cust_loadout_id` = cl.`id` where clp.`unique_id` = '?':[%1]:",str(_playerID)];
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
	//Record initial inventory
	_config = (configFile >> "CfgSurvival" >> "Inventory" >> "Default");
	_mags = getArray (_config >> "magazines");
	_wpns = getArray (_config >> "weapons");
	_bcpk = getText (_config >> "backpack");
	_randomSpot = true;
	
	//Wait for HIVE to be free
	_key = format["CHILD:203:%1:%2:%3:",_charID,[_wpns,_mags],[_bcpk,[],[]]];
	_key call server_hiveWrite;
	
};
diag_log ("LOGIN LOADED: " + str(_playerObj) + " Type: " + (typeOf _playerObj));

_isHiveOk = false;	//EDITED
if (_hiveVer >= dayz_hiveVersionNo) then {
	_isHiveOk = true;
};
//diag_log ("SERVER RESULT: " + str("X") + " " + str(dayz_hiveVersionNo));

//Server publishes variable to clients and WAITS
//_playerObj setVariable ["publish",[_charID,_inventory,_backpack,_survival,_isNew,dayz_versionNo,_model,_isHiveOk,_newPlayer],true];

dayzPlayerLogin = [_charID,_inventory,_backpack,_survival,_isNew,dayz_versionNo,_model,_isHiveOk,_newPlayer];
(owner _playerObj) publicVariableClient "dayzPlayerLogin";
