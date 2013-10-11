private ["_amount","_totalamount","_totalamountPlant1","_Plantssupported","_type","_root","_favouritezones","_randrefpoint","_PosList","_PosSelect","_debugarea","_plant","_totalamountPlant2","_centerarea","_Pos","_onRoad"];

_amount = _this select 0;
_totalamount = 0;

_totalamountPlant1 = 0;
_totalamountPlant2 = 0;
_totalamountPlant3 = 0;

while {_totalamount < _amount} do {
	//Find where plant likes
	_Plantssupported = Dayz_plants;
	_type = (_Plantssupported select floor(random(count _Plantssupported)));

	_root = configFile >> "CfgVehicles" >> _type;
	_favouritezones = getText ( _root >> "favouritezones");
	_centerarea = getMarkerPos "center";
	_randrefpoint = [_centerarea, 10, 5500, 1, 0, 50, 0] call BIS_fnc_findSafePos;
	_PosList = selectbestplaces [_randrefpoint,dayz_plantDistance,_favouritezones,10,5];
	_PosSelect = _PosList select (floor random (count _PosList));
	_Pos = _PosSelect select 0;
	_debugarea = getMarkerPos "respawn_west";
	_onRoad = isOnRoad _Pos;
	
	if ((_Pos distance _debugarea > dayz_plantDistance) and (!_onRoad) and NOT surfaceIsWater _Pos) then {
		//_clutter = createVehicle ["ClutterCutter_small_2_EP1", _Pos, [], 0, "CAN_COLLIDE"];
		//_clutter setPos _Pos;
		_plant = createVehicle [_type, _Pos, [], 0, "NONE"];
		_plant setpos _Pos;

		switch (true) do {
			//One
			case (_type == "Dayz_Plant1") : {
				_totalamountPlant1 = _totalamountPlant1 + 1;
			};
			case (_type == "Dayz_Plant2") : {
				_totalamountPlant2 = _totalamountPlant2 + 1;
			};
			case (_type == "Dayz_Plant3") : {
				_totalamountPlant3 = _totalamountPlant3 + 1;
			};
		};
	};

	if ((_totalamount % 10) == 0) then {
		sleep 5;
	};
	_totalamount = _totalamount + 1;
};

diag_log format["PLANTSPAWNER: Spawned '%1'/'%2'/'%3' - Pass's: %4", _totalamountPlant1,_totalamountPlant2,_totalamountPlant3, _totalamount];
