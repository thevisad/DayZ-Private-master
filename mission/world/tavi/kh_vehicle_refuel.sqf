private ["_target", "_caller", "_id", "_isNearFeed"];

_target = _this select 0;
_caller = _this select 1;
_id = _this select 2;

if (isNil "ib_refueling_in_progress") then { ib_refueling_in_progress = false; };

if (!ib_refueling_in_progress) then 
{
	_isNearFeed = count ((position _caller) nearObjects ["Land_A_FuelStation_Feed", 10]) > 0;

	if (!_isNearFeed) then
	{
		titleText ["You must be near a fuel station pump.", "PLAIN DOWN", 3];
		titleFadeOut 3;
	}
	else
	{
		ib_refueling_in_progress = true;

		titleText ["Refueling", "PLAIN", 3];

		while {(vehicle _caller == _target) and (local _target)} do
		{ 
			private ["_velocity", "_fuel"];
			
			_velocity = velocity _target;
			_fuel = fuel _target;

			if ((_velocity select 0 > 1) or (_velocity select 1 > 1) or (_velocity select 2 > 1)) exitWith { };
			if (_fuel >= 1.0) exitWith { };

			sleep 0.5;
		
			_fuel = _fuel + 0.005;

			if (_fuel >= 1.0) then { _fuel = 1.0; };

			_target setFuel _fuel;
		};

		titleFadeOut 1;

		ib_refueling_in_progress = false;
	};
};

