private ["_args","_ret","_muid","_qresult","_result","_newPlayer"];
_args = _this select 0;// get the key
_ret = [];//reset ret for other unimplemented calls
_result = [_args, ":"] call CBA_fnc_split;
_muid = _result select 2;
switch (_result select 1) do
{
	case "102":{
		diag_log("102");
		_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','selMPSSH','[myid=%1]']", _muid];
		_qresult = [_qresult,"|",","] call CBA_fnc_replace;
		_qresult = call compile _qresult;
		_qresult = _qresult select 0;
		_ret = ["",call compile (_qresult select 0),[call compile (_qresult select 2),call compile (_qresult select 5),call compile (_qresult select 6),call compile (_qresult select 7)],call compile ([_qresult select 3,"["",","["""","] call CBA_fnc_replace),call compile (_qresult select 1),call compile (_qresult select 4)];
	};
	case "101":{
		diag_log("101");
		_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','selIIBSM','[myuid=%1]']", _muid];
		_qresult = [_qresult,"|",","] call CBA_fnc_replace;
		if (_qresult=="[[]]") then
		{
			_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','insUNselI','[myuid=%1,myname=%2]']", _muid, _result select 4];
			_qresult = call compile _qresult;
			_qresult = _qresult select 0 ;
			_ret = ["",true,_qresult select 0,"Survivor2_DZ",dayz_hiveVersionNo];
		}else{
			_qresult = call compile _qresult;
			_qresult 	= _qresult select 0;
			_ret = ["",false,_qresult select 0,[],call compile (_qresult select 1),call compile ([_qresult select 2,"["",","["""","] call CBA_fnc_replace),[call compile (_qresult select 3),call compile (_qresult select 5),call compile (_qresult select 6)],call compile (_qresult select 4),dayz_hiveVersionNo];
		};
	};
};
diag_log(_ret);
_ret