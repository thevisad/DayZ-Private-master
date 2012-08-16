private["_updates","_playerUID","_charID","_humanity","_worldspace","_model","_newUnit","_object","_class","_position","_dir","_group","_oldUnit","_currentWpn","_muzzles","_currentAnim","_wounds"];
_playerUID 	= _this select 0;
_charID 	= _this select 1;
_model 		= _this select 2;
_object = _this select 3;
//_pname = name player;

_old = _object;
//_object allowDamage false;

_object removeEventHandler ["FiredNear",0];
_object removeEventHandler ["HandleDamage",0];
_object removeEventHandler ["Killed",0];
_object removeEventHandler ["Fired",0];

_updates = 		_object getVariable["updatePlayer",[false,false,false,false,false]];
_updates set [0,true];
_object setVariable["updatePlayer",_updates,true];
//dayz_unsaved = true;
//Logout
if (_object getVariable["USEC_injured",false]) then {
	{
		if (_object getVariable[_x,false]) then {
			_wounds set [count _wounds,_x];
		};
	} forEach USEC_typeOfWounds;
};

_humanity = _object getVariable["humanity",0];
_legs = _object getVariable ["hit_legs",0];
_arms = _object getVariable ["hit_arms",0];
_medical = [
	_object getVariable["USEC_isDead",false],
	_object getVariable["NORRN_unconscious", false],
	_object getVariable["USEC_infected",false],
	_object getVariable["USEC_injured",false],
	_object getVariable["USEC_inPain",false],
	_object getVariable["USEC_isCardiac",false],
	_object getVariable["USEC_lowBlood",false],
	_object getVariable["USEC_BloodQty",12000],
	_wounds,
	[_legs,_arms],
	_object getVariable["unconsciousTime",0],
	_object getVariable["messing",[0,0]]
];
_worldspace 	= [round(direction _object),getPosATL _object];
_zombieKills 	= _object getVariable ["zombieKills",0];
_headShots 		= _object getVariable ["headShots",0];
_humanKills 	= _object getVariable ["humanKills",0];
_banditKills 	= _object getVariable ["banditKills",0];

//Switch

_class 			= _model;

_position 		= getPosATL _object;
_dir 			= getDir _object;
_currentAnim 	= animationState _object;

//Secure Player for Transformation
_object setPosATL [0,0,0];


//BackUp Weapons and Mags
private ["_weapons","_magazines","_primweapon","_secweapon"];
_weapons 	= weapons _object;
_magazines	= magazines _object;
_primweapon	= primaryWeapon _object;
_secweapon	= secondaryWeapon _object;

//Checks
if(!(_primweapon in _weapons) && _primweapon != "") then {
	_weapons = _weapons + [_primweapon];
};

if(!(_secweapon in _weapons) && _secweapon != "") then {
	_weapons = _weapons + [_secweapon];
};

if(count _magazines == 0) then {
	_magazines = magazines _object;
};

//BackUp Backpack
private ["_newBackpackType","_backpackWpn","_backpackMag"];
	_newBackpackType = (typeOf (unitBackpack _object));
	if(_newBackpackType != "") then {
		_backpackWpn = getWeaponCargo unitBackpack _object;
		_backpackMag = getMagazineCargo unitBackpack _object;
	};

//Get Muzzle
	_currentWpn = "";
	_muzzles = getArray(configFile >> "cfgWeapons" >> _currentWpn >> "muzzles");
	if (count _muzzles > 1) then {
		_currentWpn = currentMuzzle _object;
	};
	
//Debug Message
	diag_log "Attempting to switch model";
	diag_log str(_weapons);
	diag_log str(_magazines);
	diag_log (str(_backpackWpn));
	diag_log (str(_backpackMag));

//BackUp Player Object
	_oldUnit = _object;
	
/***********************************/
//DONT USE player AFTER THIS POINT
/***********************************/

//Create New Character
	//[player] joinSilent grpNull;
	_group 		= createGroup west;
	_newUnit 	= _group createUnit [_class,getpos _object,[],0,"NONE"];
	_newUnit disableai "anim";

//Clear New Character
	{_newUnit removeMagazine _x;} forEach  magazines _newUnit;
	removeAllWeapons _newUnit;	

//Equip New Charactar
	{
		_newUnit addMagazine _x;
		//sleep 0.05;
	} forEach _magazines;
	
	{
		_newUnit addWeapon _x;
		//sleep 0.05;
	} forEach _weapons;

//Check and Compare it
	if(str(_magazines) != str(magazines _newUnit)) then {
		//Get Differecnce
		{
			_magazines = _magazines - [_x];
		} forEach (magazines _newUnit);
		
		//Add the Missing
		{
			_newUnit addMagazine _x;
			//sleep 0.2;
		} forEach _magazines;
	};
	
	if(str(_weapons) != str(weapons _newUnit)) then {
		//Get Differecnce
		{
			_weapons = _weapons - [_x];
		} forEach (weapons _newUnit);
	
		//Add the Missing
		{
			_newUnit addWeapon _x;
			//sleep 0.2;
		} forEach _weapons;
	};
	
	if(_primweapon !=  (primaryWeapon _newUnit)) then {
		_newUnit addWeapon _primweapon;		
	};

	if(_secweapon != (secondaryWeapon _newUnit) && _secweapon != "") then {
		_newUnit addWeapon _secweapon;		
	};

//Add and Fill BackPack
	if (!isNil "_newBackpackType") then {
		if (_newBackpackType != "") then {
			_newUnit addBackpack _newBackpackType;
			_oldBackpack = dayz_myBackpack;
			dayz_myBackpack = unitBackpack _newUnit;


			//Fill backpack contents
			//Weapons
			_backpackWpnTypes = [];
			_backpackWpnQtys = [];
			if (count _backpackWpn > 0) then {
				_backpackWpnTypes = _backpackWpn select 0;
				_backpackWpnQtys = 	_backpackWpn select 1;
			};
			_countr = 0;
			{
				dayz_myBackpack addWeaponCargoGlobal [_x,(_backpackWpnQtys select _countr)];
				_countr = _countr + 1;
			} forEach _backpackWpnTypes;
			//magazines
			_backpackmagTypes = [];
			_backpackmagQtys = [];
			if (count _backpackmag > 0) then {
				_backpackmagTypes = _backpackMag select 0;
				_backpackmagQtys = 	_backpackMag select 1;
			};
			_countr = 0;
			{
				dayz_myBackpack addmagazineCargoGlobal [_x,(_backpackmagQtys select _countr)];
				_countr = _countr + 1;
			} forEach _backpackmagTypes;
		};
	};
//Debug Message
	diag_log "Swichtable Unit Created. Equipment:";
	diag_log str(weapons _newUnit);
	diag_log str(magazines _newUnit);	
	diag_log str(getWeaponCargo unitBackpack _newUnit);
	diag_log str(getMagazineCargo unitBackpack _newUnit);

//Make New Unit Playable
	_newUnit setPosATL _position;
	_newUnit setDir _dir;
	addSwitchableUnit _newUnit;
	setPlayable _newUnit;


	
	if(_currentWpn != "") then {_newUnit selectWeapon _currentWpn;};	
	

//Login

//set medical values
if (count _medical > 0) then {
	_newunit setVariable["USEC_isDead",(_medical select 0),true];
	_newunit setVariable["NORRN_unconscious", (_medical select 1), true];
	_newunit setVariable["USEC_infected",(_medical select 2),true];
	_newunit setVariable["USEC_injured",(_medical select 3),true];
	_newunit setVariable["USEC_inPain",(_medical select 4),true];
	_newunit setVariable["USEC_isCardiac",(_medical select 5),true];
	_newunit setVariable["USEC_lowBlood",(_medical select 6),true];
	_newunit setVariable["USEC_BloodQty",(_medical select 7),true];
	_newunit setVariable["unconsciousTime",(_medical select 10),true];
	
	//Add Wounds
	{
		_newunit setVariable[_x,true,true];
		[_newunit,_x,_hit] spawn fnc_usec_damageBleed;
		usecBleed = [_newunit,_x,0];
		publicVariable "usecBleed";
	} forEach (_medical select 8);
	
	//Add fractures
	_fractures = (_medical select 9);
	_newunit setVariable ["hit_legs",(_fractures select 0),true];
	_newunit setVariable ["hit_hands",(_fractures select 1),true];
} else {
	//Reset Fractures
	_newunit setVariable ["hit_legs",0,true];
	_newunit setVariable ["hit_hands",0,true];
	_newunit setVariable ["USEC_injured",false,true];
	_newunit setVariable ["USEC_inPain",false,true];	
};

//General Stats
_newunit setVariable["characterID",str(_charID),true];
_newunit setVariable["worldspace",_worldspace,true];
dayzPlayerMorph = [_charID,_newunit,_playerUID,[_zombieKills,_headShots,_humanKills,_banditKills],_humanity];
publicVariable "dayzPlayerMorph";
if (isServer) then {
	dayzPlayerMorph call server_playerMorph;
};
call dayz_resetSelfActions;
//eh_player_killed = _newunit addeventhandler ["FiredNear",{_this call player_weaponFiredNear;} ];
_a = call compile format["player%1", getPlayerUID player];
_a = "Test";
//t_name = _pname;
_mydamage_eh1 = _newunit addeventhandler ["HandleDamage",{[_this] call disco_handler;}];
//mydamage_eh3 = _newunit addEventHandler ["Killed", {[dayz_characterID,0,_body,_playerID,dayz_playerName];}];

_newunit allowDamage true;

_newunit addWeapon "Loot";
_newunit addWeapon "Flare";

sleep 0.1;
deleteVehicle _old;
botPlayers = botPlayers + [_playerUID];
diag_log (format["botPlayers: %1", botPlayers]);

sleep 40;
//diag_log ("DISCONNECT START (i): " + _playerName + " (" + str(_playerUID) + ") Object: " + str(_object) );

//[_newunit,[],true] call server_playerSync;
_newunit removeAllEventHandlers "handleDamage";
_backpack = unitBackpack _newunit;
_playerBackp = [typeOf _backpack,getWeaponCargo _backpack,getMagazineCargo _backpack];

if (_newunit getVariable["USEC_injured",false]) then {
			{
				if (_newunit getVariable[_x,false]) then {
					_wounds set [count _wounds,_x];
				};
			} forEach USEC_typeOfWounds;
		};


		_legs = _newunit getVariable ["hit_legs",0];
		_arms = _newunit getVariable ["hit_arms",0];
		_medical = [
			_newunit getVariable["USEC_isDead",false],
			_newunit getVariable["NORRN_unconscious", false],
			_newunit getVariable["USEC_infected",false],
			_newunit getVariable["USEC_injured",false],
			_newunit getVariable["USEC_inPain",false],
			_newunit getVariable["USEC_isCardiac",false],
			_newunit getVariable["USEC_lowBlood",false],
			_newunit getVariable["USEC_BloodQty",12000],
			_wounds,
			[_legs,_arms],
			_newunit getVariable["unconsciousTime",0],
			_newunit getVariable["messing",[0,0]]
		];

if ( typeName(_currentWpn) == "STRING" ) then {
	_muzzles = getArray(configFile >> "cfgWeapons" >> _currentWpn >> "muzzles");
	if (count _muzzles > 1) then {
		_currentWpn = currentMuzzle _newunit;
	};	
} else {
	//diag_log ("DW_DEBUG: _currentWpn: " + str(_currentWpn));
	_currentWpn = "";
};
_temp = round(_newunit getVariable ["temperature",100]);
_currentState = [_currentWpn,_currentAnim,_temp];			
				

//Wait for HIVE to be free
//Send request
if (str(_worldspace) != "[0,[0,0,0]]") then { // Костыль от кривых сохранений в базе
	_key = format["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:",_charID,_worldspace,[weapons _newunit,magazines _newunit],_playerBackp,_medical,false,false,0,0,0,0,_currentState,0,0,_model,0];
	diag_log ("HIVE: ontimer WRITE: "+ str(_key) + " / " + _charID);
	_key call server_hiveWrite;
} else {
	diag_log ("DiscoMorph: WORLDSPACE 0,0,0 FOUND in CID: " + _charID);
};


//_id = [_playerUID,_charID,2] spawn dayz_recordLogin;

if (alive _newunit) then {
		_myGroup = group _newunit;
		deleteVehicle _newunit;
		deleteGroup group _newunit;
};
botPlayers = botPlayers - [_playerUID];