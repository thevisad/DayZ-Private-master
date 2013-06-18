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
		case "Military":  {
		  lootType[] = {
				{"M9","weapon",0.05}, {"M16A2","weapon",0.05}, {"M16A2GL","weapon",0.02}, {"M9SD","weapon",0.01}, {"MakarovSD","weapon",0.01}, {"AK_74","weapon",0.06}, {"M4A1_Aim","weapon",0.03}, {"AKS_74_kobra","weapon",0.06}, {"AKS_74_U","weapon",0.04}, 
				{"AK_47_M","weapon",0.04}, {"M24","weapon",0.03}, {"M1014","weapon",0.06}, {"DMR_DZ","weapon",0.03}, {"M4A1","weapon",0.04}, {"M14_EP1","weapon",0.03}, {"UZI_EP1","weapon",0.05}, {"Remington870_lamp","weapon",0.05}, {"glock17_EP1","weapon",0.08},
				{"MP5A5","weapon",0.04}, {"MP5SD","weapon",0.01}, {"M4A3_CCO_EP1","weapon",0.02}, {"Binocular","weapon",0.05}, {"ItemFlashlightRed","military",0.06}, {"ItemKnife","military",0.06}, {"ItemGPS","weapon",0.01}, {"ItemMap","military",0.03}, {"DZ_British_ACU","object",0.02}, 
				{"DZ_CivilBackpack_EP1","object",0.01}, {"ItemEtool","weapon",0.03}, {"ItemSandbag","magazine",0.04}, {"","military",0.70}, {"","generic",0.10}, {"","trash",0.30}
			};
		};

		case "Residential": {
			lootType[] = {
				{"ItemSodaMdew","magazine",0.01}, {"ItemWatch","generic",0.05}, {"ItemCompass","generic",0.05}, {"ItemMap","weapon",0.03}, {"Makarov","weapon",0.04}, {"Colt1911","weapon",0.04}, {"ItemFlashlight","generic",0.06}, 
				{"ItemKnife","generic",0.07}, {"ItemMatchbox","generic",0.06}, {"LeeEnfield","weapon",0.03}, {"revolver_EP1","weapon",0.04}, {"DZ_Patrol_Pack_EP1","object",0.05}, {"DZ_Assault_Pack_EP1","object",0.04}, 
				{"DZ_Czech_Vest_Puch","object",0.03}, {"DZ_ALICE_Pack_EP1","object",0.01}, {"DZ_TK_Assault_Pack_EP1","object",0.02}, {"Winchester1866","weapon",0.03}, {"MeleeBaseBallBat","weapon",0.02}, {"WeaponHolder_ItemTent","object",0.01}, 
				{"Crossbow_DZ","weapon",0.01}, {"Binocular","weapon",0.06}, {"PartWoodPile","magazine",0.06}, {"Skin_Camo1_DZ","magazine",0.01}, {"Skin_Sniper1_DZ","magazine",0.01}, {"WeaponHolder_ItemCrowbar","object",0.08}, 
				{"MR43","weapon",0.03}, {"ItemBookBible","magazine",0.02}, {"WeaponHolder_ItemFuelcan","object",0.03}, {"","military",0.10}, {"","generic",0.60}, {"","trash",0.40}
			};
		};

		case "Industrial": {
			lootType[] = {
				{"WeaponHolder_PartGeneric","object",0.04}, {"WeaponHolder_PartWheel","object",0.05}, {"WeaponHolder_PartFueltank","object",0.02}, {"WeaponHolder_PartEngine","object",0.02}, {"WeaponHolder_PartGlass","object",0.04}, 
				{"WeaponHolder_PartVRotor","object",0.01}, {"WeaponHolder_ItemJerrycan","object",0.04}, {"WeaponHolder_ItemHatchet","object",0.05}, {"WeaponHolder_ItemFuelcan","object",0.03}, {"ItemKnife","military",0.03}, 
				{"ItemToolbox","weapon",0.06}, {"ItemWire","magazine",0.01}, {"ItemTankTrap","magazine",0.04}, {"","military",0.10}, {"","generic",0.60}, {"","trash",0.40}
			};
		};

		case "HeliCrash":  {
			lootType[] = {
				{"FN_FAL","weapon",0.04}, {"bizon_silenced","weapon",0.05}, {"M14_EP1","weapon",0.05}, {"FN_FAL_ANPVS4","weapon",0.01}, {"Mk_48_DZ","weapon",0.03}, {"M249_DZ","weapon",0.04}, {"BAF_L85A2_RIS_SUSAT","weapon",0.03}, {"DMR","weapon",0.06},
				{"MedBox0","object",0.05}, {"NVGoggles","weapon",0.01}, {"AmmoBoxSmall_556","object",0.05}, {"AmmoBoxSmall_762","object",0.05}, {"Skin_Camo1_DZ","magazine",0.08}, {"Skin_Sniper1_DZ","magazine",0.05},	{"G36C","weapon",0.03}, {"G36C_camo","weapon",0.03},
				{"G36A_camo","weapon",0.03}, {"G36K_camo","weapon",0.03}, {"100Rnd_762x54_PK","magazine",0.05}, {"","military",1.00}, {"","medical",0.5}
			};
		};	

		case "Farm": {
			lootType[] =	{
				{"WeaponHolder_ItemJerrycan","object",0.03}, {"huntingrifle","weapon",0.02}, {"LeeEnfield","weapon",0.03}, {"Winchester1866","weapon",0.03}, {"Crossbow_DZ","weapon",0.03}, {"PartWoodPile","magazine",0.08}, 
				{"WeaponHolder_ItemHatchet","object",0.05},	{"MR43","weapon",0.01}, {"MeleeMachete","weapon",0.04}, {"","military",0.10}, {"","generic",0.60}, {"","trash",0.40}
			};
		};


		case "Supermarket": {	
			lootType[] = {
				{"ItemWatch","generic",0.05}, {"ItemCompass","generic",0.01}, {"ItemMap","weapon",0.06}, {"Makarov","weapon",0.02}, {"Colt1911","weapon",0.02}, {"ItemFlashlight","generic",0.05}, {"ItemKnife","generic",0.02}, 
				{"ItemMatchbox","generic",0.05}, {"LeeEnfield","weapon",0.01}, {"revolver_EP1","weapon",0.01}, {"DZ_Patrol_Pack_EP1","object",0.05}, {"DZ_Assault_Pack_EP1","object",0.04}, {"DZ_Czech_Vest_Puch","object",0.03}, 
				{"DZ_ALICE_Pack_EP1","object",0.02}, {"DZ_TK_Assault_Pack_EP1","object",0.02}, {"Winchester1866","weapon",0.03}, {"WeaponHolder_ItemTent","object",0.01}, {"Crossbow_DZ","weapon",0.01}, {"Binocular","weapon",0.03}, 
				{"PartWoodPile","magazine",0.04}, {"MR43","weapon", 0.01}, {"","food",0.07}, {"","military",0.03}, {"","generic",0.60}, {"","trash",0.40}
			};
		};


		case "Hospital": {	
			lootType[] = {
				{"","trash",0.2}, {"","hospital",0.5}, {"MedBox0","object",0.5}
			};
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