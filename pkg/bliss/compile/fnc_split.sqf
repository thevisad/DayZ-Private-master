private ["_string", "_separator", "_strar", "_separ", "_countstr", "_countsepstr", "_split", "_curidx", "_curstr", "_char", "_sepidx", "_sephelper", "_newidx", "_cchar", "_schar"];

_string    = _this select 0;
_separator = _this select 1;

_strar = toArray _string;
_separ = toArray _separator;
_countstr = count _strar;
_countsepstr = count _separ;
if (_countsepstr > _countstr) exitWith {[]};
_split = [];

if (_separator == "") then {
	{
		_split set [count _split, toString [_x]];
	} forEach _strar;
} else {
	_curidx = 0;
	_curstr = [];
	while {_curidx < _countstr} do {
		_char = _strar select _curidx;

		if (_char != _separ select 0) then {
			_curstr set [count _curstr, _char];
		} else {
			_sepidx = 0;
			_sephelper = [];
			_newidx = 0;

			for "_i" from _curidx to _curidx + _countsepstr do {
				if (_sepidx >= _countsepstr) exitWith {};
				if (_i >= _countstr) exitWith {};
				_cchar = _strar select _i;
				_schar = _separ select _sepidx;
				if (_cchar != _schar) exitWith {};
				_sephelper set [count _sephelper, _cchar];
				_sepidx = _sepidx + 1;
				_newidx = _i;
			};

			if (count _sephelper == _countsepstr) then { // match
				_curidx = _newidx;
				_split set [count _split, toString _curstr];
				_curstr = [];
			} else {
				_curstr set [count _curstr, _char];
			};
		};
		_curidx = _curidx + 1;
	};

	if (count _curstr > 0) then {
		_split set [count _split, toString _curstr];
	} else {
		_split set [count _split, ""];
	};
};

_split;
