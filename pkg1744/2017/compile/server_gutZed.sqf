private ["_qty","_item","_meat","_loop","_timer"];
_item = _this select 0;
_qty = 4;
_meat = 0;
_loop = true;
if (local _item) then {
	for "_x" from 1 to _qty do {
		_item addMagazine "RawInfectedFlesh";
	};
	sleep 2;
	_timer = time;
	while {_loop} do {
		_meat = count magazines _item;
		if (_meat == 0) then {_loop = false};
		if ((time - _timer) > 300) then {_loop = false};
		sleep 1;
	};
	dayzHideBody = _item;
	publicVariable "dayzHideBody";
	hideBody _item;
	sleep 10;
	deleteVehicle _item;
};