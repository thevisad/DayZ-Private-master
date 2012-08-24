private ["_string", "_pattern", "_replacement"];
_string = _this select 0;
_pattern = _this select 1;
_replacement = _this select 2;

[[_string, _pattern] call fnc_split, _replacement] call fnc_join;
