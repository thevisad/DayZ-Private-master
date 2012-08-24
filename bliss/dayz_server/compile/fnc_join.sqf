private ["_array", "_separator", "_joined", "_element"];
_array     = _this select 0;
_separator = _this select 1;

if (count _array > 0) then {
	_element = _array select 0;
	_joined = if (typeName(_element) == "STRING") then { _element } else { str _element };

	for "_i" from 1 to ((count _array) - 1) do {
		_element = _array select _i;
		_element = if (typeName(_element) == "STRING") then { _element } else { str _element };
		_joined = _joined + _separator + _element;
	};
} else {
	_joined = "";
};

_joined;
