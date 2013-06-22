private ["_characterID","_playerObj","_playerID","_dummy","_worldspace","_state","_doLoop","_key","_primary","_medical","_stats","_humanity","_randomSpot","_position","_debug","_distance","_fractures","_score","_findSpot","_mkr","_j","_isIsland","_w","_clientID"];//diag_log ("SETUP: attempted with " + str(_this));

//diag_log(format["%1 DEBUG %2", __FILE__, _this]);
_characterID = _this select 0;
_playerObj = _this select 1;
_playerID = getPlayerUID _playerObj;

#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

if (isNull _playerObj) exitWith {
	diag_log ("SETUP INIT FAILED: Exiting, player object null: " + str(_playerObj));
};

if (_playerID == "") then {
	_playerID = getPlayerUID _playerObj;
};

if (_playerID == "") exitWith {
	diag_log ("SETUP INIT FAILED: Exiting, no player ID: " + str(_playerObj));
};

private["_dummy"];
_dummy = getPlayerUID _playerObj;
if ( _playerID != _dummy ) then { 
	diag_log format["DEBUG: _playerID miscompare with UID! _playerID:%1",_playerID]; 
	_playerID = _dummy;
};

//Variables
_worldspace = [];


_state = [];

//Do Connection Attempt
_doLoop = 0;
while {_doLoop < 5} do {
	_key = format["CHILD:102:%1:",_characterID];
	_primary = _key call server_hiveReadWrite;
	if (count _primary > 0) then {
		if ((_primary select 0) != "ERROR") then {
			_doLoop = 9;
		};
	};
	_doLoop = _doLoop + 1;
};

if (isNull _playerObj or !isPlayer _playerObj) exitWith {
	diag_log ("SETUP RESULT: Exiting, player object null: " + str(_playerObj));
};

//Wait for HIVE to be free
//diag_log ("SETUP: RESULT: Successful with " + str(_primary));

_medical = _primary select 1;
_stats = _primary select 2;
_state = _primary select 3;
_worldspace = _primary select 4;
_humanity = _primary select 5;

//Set position
_randomSpot = false;

//diag_log ("WORLDSPACE: " + str(_worldspace));

if (count _worldspace > 0) then {

	_position = _worldspace select 1;
	if (count _position < 3) then {
		//prevent debug world!
		_randomSpot = true;
	};
	_debug = getMarkerpos "respawn_west";
	_distance = _debug distance _position;
	if (_distance < 2000) then {
		_randomSpot = true;
	};
	
	_distance = [0,0,0] distance _position;
	if (_distance < 500) then {
		_randomSpot = true;
	};

	//_playerObj setPosATL _position;
} else {
	_randomSpot = true;
};

//diag_log ("LOGIN: Location: " + str(_worldspace) + " doRnd?: " + str(_randomSpot));

//set medical values
if (count _medical > 0) then {
	_playerObj setVariable["USEC_isDead",(_medical select 0),true];
	_playerObj setVariable["NORRN_unconscious", (_medical select 1), true];
	_playerObj setVariable["USEC_infected",(_medical select 2),true];
	_playerObj setVariable["USEC_injured",(_medical select 3),true];
	_playerObj setVariable["USEC_inPain",(_medical select 4),true];
	_playerObj setVariable["USEC_isCardiac",(_medical select 5),true];
	_playerObj setVariable["USEC_lowBlood",(_medical select 6),true];
	_playerObj setVariable["USEC_BloodQty",(_medical select 7),true];
	
	_playerObj setVariable["unconsciousTime",(_medical select 10),true];
	
//	if (_playerID in dayz_disco) then {
//		_playerObj setVariable["NORRN_unconscious",true, true];
//		_playerObj setVariable["unconsciousTime",300,true];
//	} else {
//		_playerObj setVariable["unconsciousTime",(_medical select 10),true];
//	};
	
	//Add bleeding Wounds
	{
		_playerObj setVariable["hit_"+_x,true, true];
	} forEach (_medical select 8);
	
	//Add fractures
	_fractures = (_medical select 9);
	_playerObj setVariable ["hit_legs",(_fractures select 0),true];
	_playerObj setVariable ["hit_hands",(_fractures select 1),true];
	
	if (count _medical > 11) then {
		//Additional medical stats
		_playerObj setVariable ["messing",(_medical select 11),true];
	};
	
} else {
	//Reset bleedings wounds
	call fnc_usec_resetWoundPoints;
	//Reset Fractures
	_playerObj setVariable ["hit_legs",0,true];
	_playerObj setVariable ["hit_hands",0,true];
	_playerObj setVariable ["USEC_injured",false,true];
	_playerObj setVariable ["USEC_inPain",false,true];
	_playerObj setVariable ["messing",[0,0],true];
};
	
if (count _stats > 0) then { 
	//register stats
	_playerObj setVariable["zombieKills",(_stats select 0),true];
	_playerObj setVariable["headShots",(_stats select 1),true];
	_playerObj setVariable["humanKills",(_stats select 2),true];
	_playerObj setVariable["banditKills",(_stats select 3),true];
	_playerObj addScore (_stats select 1);
	
	//Save Score
	_score = score _playerObj;
	_playerObj addScore ((_stats select 0) - _score);
	
	//record for Server JIP checks
	_playerObj setVariable["zombieKills_CHK",(_stats select 0)];
	_playerObj setVariable["headShots_CHK",(_stats select 1)];
	//_playerObj setVariable["humanKills_CHK",(_stats select 2)]; // not used???
	//_playerObj setVariable["banditKills_CHK",(_stats select 3)]; // not used????
	if (count _stats > 4) then {
		if (!(_stats select 3)) then {
			_playerObj setVariable["selectSex",true,true];
		};
	} else {
		_playerObj setVariable["selectSex",true,true];
	};
} else {
	//Save initial loadout
	//register stats
	_playerObj setVariable["zombieKills",0,true];
	_playerObj setVariable["humanKills",0,true];
	_playerObj setVariable["banditKills",0,true];
	_playerObj setVariable["headShots",0,true];
	
	//record for Server JIP checks
	_playerObj setVariable["zombieKills_CHK",0];
	//_playerObj setVariable["humanKills_CHK",0,true]; // not used??
	//_playerObj setVariable["banditKills_CHK",0,true]; // not used????
	_playerObj setVariable["headShots_CHK",0];
};

if (_randomSpot) then {
	private["_counter","_position","_isNear","_isZero","_mkr"];
	if (!isDedicated) then {
		endLoadingScreen;
	};
	
	//spawn into random
	_findSpot = true;
	_mkr = [];
	_position = [0,0,0];
	for [{_j=0},{_j<=100 AND _findSpot},{_j=_j+1}] do {
		_mkr = getMarkerPos ("spawn" + str(floor(random 5)));
		_position = ([_mkr,0,500,10,0,2,1] call BIS_fnc_findSafePos);
		if ((count _position >= 2) // !bad returned position
			AND {(_position distance _mkr < 500)}) then { // !ouside the disk
			_position set [2, 0];
			if (((ATLtoASL _position) select 2 > 2.5) //! player's feet too wet
			AND {({alive _x} count (_position nearEntities ["Man",150]) == 0)}) then { // !too close from other players/zombies
				_pos = +(_position);
				_isIsland = false;		//Can be set to true during the Check
				// we check over a 809-meter cross line, with an effective interlaced step of 5 meters
				for [{_w = 0}, {_w != 809}, {_w = ((_w + 17) % 811)}] do {
					//if (_w < 17) then { diag_log format[ "%1 loop starts with _w=%2", __FILE__, _w]; };
					_pos = [((_pos select 0) - _w),((_pos select 1) + _w),(_pos select 2)];
					if(surfaceisWater _pos) exitWith {
						_isIsland = true;
					};
				};
				if (_isIsland) then {_findSpot = false};
			};
		};
		//diag_log format["%1: pos:%2 _findSpot:%3", __FILE__, _position, _findSpot];
	};
	if (_findSpot) exitWith {
		diag_log format["%1: Error, failed to find a suitable spawn spot for player. area:%2",__FILE__, _mkr];
	};
	_worldspace = [0,_position];
};


//Record player for management
dayz_players set [count dayz_players,_playerObj];

//record player pos locally for server checking
_playerObj setVariable["characterID",_characterID,true];
_playerObj setVariable["humanity",_humanity,true];
_playerObj setVariable["humanity_CHK",_humanity];
//_playerObj setVariable["worldspace",_worldspace,true];
//_playerObj setVariable["state",_state,true];
_playerObj setVariable["lastPos",getPosATL _playerObj];

dayzPlayerLogin2 = [_worldspace,_state];
_clientID = owner _playerObj;
_clientID publicVariableClient "dayzPlayerLogin2";

//record time started
_playerObj setVariable ["lastTime",time];
//_playerObj setVariable ["model_CHK",typeOf _playerObj];

#ifdef LOGIN_DEBUG
diag_log format["LOGIN PUBLISHING: UID#%1 CID#%2 %3 as %4 should spawn at %5", getPlayerUID _playerObj, _characterID, _playerObj call fa_plr2str, typeOf _playerObj, (_worldspace select 1) call fa_coor2str];
#endif

PVDZ_plr_Login1 = null;
PVDZ_plr_Login2 = null;

//Save Login
