private["_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray"];

waitUntil{!isNil "BIS_fnc_selectRandom"};
if (isDedicated) then {
	_position = [getMarkerPos "center",0,7000,10,0,2000,0] call BIS_fnc_findSafePos;

	_randomvehicle = ["Misc_cargo_cont_net1","Misc_cargo_cont_net2","Misc_cargo_cont_net3"] call BIS_fnc_selectRandom;
	_vehicleloottype = ["Residential","Industrial","Military","Farm","Supermarket","Hospital"] call BIS_fnc_selectRandom;

	_veh = createVehicle [_randomvehicle,_position, [], 0, "CAN_COLLIDE"];
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
	_veh setVariable ["ObjectID",1,true];

	if (_randomvehicle == "Misc_cargo_cont_net1") then { _num = round(random 3) + 3; };
	if (_randomvehicle == "Misc_cargo_cont_net2") then { _num = round(random 6) + 4; };
	if (_randomvehicle == "Misc_cargo_cont_net3") then { _num = round(random 12) + 5; };

	switch (_vehicleloottype) do {
		case "Military": {
			_itemType = [["M9", "weapon"], ["M16A2", "weapon"], ["M16A2GL", "weapon"], ["M9SD", "weapon"], ["AK_47_M", "weapon"], ["AK_74", "weapon"], ["M4A1_Aim", "weapon"], ["AKS_74_kobra", "weapon"], ["AKS_74_U", "weapon"], ["AK_47_M", "weapon"], ["M24", "weapon"], ["M1014", "weapon"], ["DMR", "weapon"], ["M4A1", "weapon"], ["M14_EP1", "weapon"], ["UZI_EP1", "weapon"], ["Remington870_lamp", "weapon"], ["glock17_EP1", "weapon"], ["MP5A5", "weapon"], ["MP5SD", "weapon"], ["M4A3_CCO_EP1", "weapon"], ["Binocular", "weapon"], ["ItemFlashlightRed", "military"], ["ItemKnife", "military"], ["ItemGPS", "weapon"], ["ItemMap", "military"], ["DZ_Assault_Pack_EP1", "object"], ["DZ_Patrol_Pack_EP1", "object"], ["DZ_Backpack_EP1", "object"], ["", "medical"], ["", "generic"], ["", "military"], ["ItemEtool", "weapon"], ["ItemSandbag", "magazine"]];
			_itemChance = [0.05, 0.05, 0.01, 0.02, 0.2, 0.15, 0.01, 0.08, 0.05, 0.05, 0.01, 0.1, 0.01, 0.02, 0.01, 0.05, 0.08, 0.1, 0.04, 0.02, 0.01, 0.06, 0.1, 0.1, 0.01, 0.05, 0.06, 0.04, 0.02, 0.1, 1.0, 2.5, 0.05, 0.02];
		};
		case "Residential": {
			_itemType = [["ItemSodaMdew", "magazine"], ["ItemWatch", "generic"], ["ItemCompass", "generic"], ["ItemMap", "weapon"], ["Makarov", "weapon"], ["Colt1911", "weapon"], ["ItemFlashlight", "generic"], ["ItemKnife", "generic"], ["ItemMatchbox", "generic"], ["", "generic"], ["LeeEnfield", "weapon"], ["revolver_EP1", "weapon"], ["CZ_VestPouch_EP1", "object"], ["DZ_CivilBackpack_EP1", "object"], ["DZ_ALICE_Pack_EP1", "object"], ["Winchester1866", "weapon"], ["WeaponHolder_ItemTent", "object"], ["", "military"], ["", "trash"], ["Crossbow", "weapon"], ["Binocular", "weapon"], ["PartWoodPile", "magazine"], ["Skin_Camo1_DZ", "magazine"], ["Skin_Sniper1_DZ", "magazine"], ["WeaponHolder_MeleeCrowbar", "object"], [MR43, "weapon"]];
			_itemChance = [0.01, 0.15, 0.05, 0.03, 0.13, 0.05, 0.03, 0.08, 0.06, 2, 0.06, 0.04, 0.01, 0.03, 0.03, 0.01, 0.01, 0.03, 0.5, 0.01, 0.06, 0.06, 0.01, 0.01, 0.08, 0.03];
		};
		case "Industrial": {
			_itemType = [["", "generic"], ["", "trash"], ["", "military"], ["WeaponHolder_PartGeneric", "object"], ["WeaponHolder_PartWheel", "object"], ["WeaponHolder_PartFueltank", "object"], ["WeaponHolder_PartEngine", "object"], ["WeaponHolder_PartGlass", "object"], ["WeaponHolder_PartVRotor", "object"], ["WeaponHolder_ItemJerrycan", "object"], ["WeaponHolder_ItemHatchet", "object"], ["ItemKnife", "military"], ["ItemToolbox", "weapon"], ["ItemWire", "magazine"], ["ItemTankTrap", "magazine"]];
			_itemChance = [0.18, 0.29, 0.04, 0.04, 0.05, 0.02, 0.01, 0.04, 0.01, 0.04, 0.11, 0.07, 0.02, 0.06, 0.04];	
		};
		case "HeliCrash": {
			_itemType = [[FN_FAL, "weapon"], ["bizon_silenced", "weapon"], [M14_EP1, "weapon"], [FN_FAL_ANPVS4, "weapon"], [M107_DZ, "weapon"], ["BAF_AS50_scoped", "weapon"], ["Mk_48_DZ", "weapon"], [M249_DZ, "weapon"], [BAF_L85A2_RIS_CWS, "weapon"], [DMR, "weapon"], ["", "military"], ["", "medical"], ["MedBox0", "object"], ["NVGoggles", "weapon"], ["AmmoBoxSmall_556", "object"], ["AmmoBoxSmall_762", "object"], ["Skin_Camo1_DZ", "magazine"], ["Skin_Sniper1_DZ", "magazine"]];
			_itemChance = [0.02, 0.05, 0.05, 0.02, 0.01, 0.02, 0.03, 0.05, 0.01, 0.1, 1, 0.5, 0.1, 0.01, 0.1, 0.1, 0.08, 0.05];
		};
		case "Farm": {
			itemType = [["WeaponHolder_ItemJerrycan", "object"], ["", "generic"], ["huntingrifle", "weapon"], ["LeeEnfield", "weapon"], ["Winchester1866", "weapon"], ["", "trash"], ["Crossbow", "weapon"], ["PartWoodPile", "magazine"], ["WeaponHolder_ItemHatchet", "object"], [MR43, "weapon"], ["TrapBear", "magazine"]];
			itemChance = [0.06, 0.28, 0.01, 0.04, 0.03, 0.22, 0.03, 0.11, 0.17, 0.06, 0.01];	
		};
		case "Supermarket": {	
			_itemType = [["ItemWatch", "generic"], ["ItemCompass", "generic"], ["ItemMap", "weapon"], ["Makarov", "weapon"], ["Colt1911", "weapon"], ["ItemFlashlight", "generic"], ["ItemKnife", "generic"], ["ItemMatchbox", "generic"], ["", "generic"], ["LeeEnfield", "weapon"], ["revolver_EP1", "weapon"], ["CZ_VestPouch_EP1", "object"], ["DZ_CivilBackpack_EP1", "object"], ["DZ_ALICE_Pack_EP1", "object"], ["Winchester1866", "weapon"], ["WeaponHolder_ItemTent", "object"], ["", "food"], ["", "trash"], ["Crossbow", "weapon"], ["Binocular", "weapon"], ["PartWoodPile", "magazine"], [MR43, "weapon"]];
			_itemChance = [0.15, 0.01, 0.05, 0.02, 0.02, 0.05, 0.02, 0.05, 0.05, 0.01, 0.01, 0.01, 0.02, 0.03, 0.01, 0.01, 0.3, 0.15, 0.01, 0.05, 0.02, 0.01];
		};
		case "Hospital": {
			_itemType = [["", "trash"], ["", "hospital"], ["MedBox0", "object"]];
			_itemChance = [0.2, 0.5, 0.5];
		};
	};

	diag_log("DEBUG: Spawning a " + str (_randomvehicle) + " at " + str(_position) + " with loot type " + str(_vehicleloottype) + " With total loot drops = " + str(_num));

	waituntil {!isnil "fnc_buildWeightedArray"};

	_weights = [];
	_weights = [_itemType,_itemChance] call fnc_buildWeightedArray;
	for "_x" from 1 to _num do {
		_index = _weights call BIS_fnc_selectRandom;
		sleep 1;
		if (count _itemType > _index) then {
			_iArray = _itemType select _index;
			_iArray set [2,_position];
			_iArray set [3,10];
			_iArray call spawn_loot;
			_nearby = _position nearObjects ["WeaponHolder",20];
			{
				_x setVariable ["permaLoot",true];
			} forEach _nearBy;
		};
	};
};