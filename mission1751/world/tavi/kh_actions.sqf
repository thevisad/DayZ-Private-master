private ["_vehicle", "_vehicle_refuel_id"];

_vehicle = objNull;

diag_log "Running ""kh_actions"".";

while {true} do
{
	if (!isNull player) then 
	{
		private "_currentVehicle";

		_currentVehicle = vehicle player;

		if (_vehicle != _currentVehicle) then 
		{ 
			if (!isNull _vehicle) then
			{
				_vehicle removeAction _vehicle_refuel_id; 
				_vehicle = objNull;
			};

			if (_currentVehicle != player) then
			{
				_vehicle = _currentVehicle;

				_vehicle_refuel_id = _vehicle addAction ["Refuel", "kh_vehicle_refuel.sqf", [], -1, false, false, "", 
				  "vehicle _this == _target && local _target"];
			};
		};
	};

	sleep 2;
}

