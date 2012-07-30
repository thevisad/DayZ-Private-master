private ["_args","_ret","_muid","_qresult","_result","_time","_m","_h","_mm","_y","_date"];
_args = _this select 0;// get the key
_ret = [];//reset ret for other unimplemented calls
_result = [_args, ":"] call CBA_fnc_split;
_muid = _result select 2;
switch (_result select 1) do
{
	case "102":{
		//Setup
		//diag_log("SETUP:102");
		_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','selMPSSH','[myid=%1]']", _muid];
		_qresult = [_qresult,"|",","] call CBA_fnc_replace;
		_qresult = call compile _qresult;
		_qresult = _qresult select 0;
		_ret = ["",call compile (_qresult select 0),[call compile (_qresult select 2),call compile (_qresult select 5),call compile (_qresult select 6),call compile (_qresult select 7)],call compile ([_qresult select 3,"["",","["""","] call CBA_fnc_replace),call compile (_qresult select 1),call compile (_qresult select 4)];
	};
	case "101":{
		//Login
		//diag_log("LOGIN:101");
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
	case "307":{
		//Get Time
		//diag_log("GETTIME:307");
		_qresult = "Arma2Net.Unmanaged" callExtension format["Arma2NETMySQL ['dayz','getTime','myinstance=%1']",dayz_instance];
		_qresult = call compile _qresult;
		_qresult = _qresult select 0;
		_date = _qresult select 0;
		_date = [_date,"-"] call CBA_fnc_split;
		_time = [_qresult select 1,":"] call CBA_fnc_split;
		_m = call compile (_date select 1);
		_y = call compile (_date select 2);
		_d = call compile (_date select 0);
		_h = call compile (_time select 0);
		_mm = call compile (_time select 1);
		_ret = ["PASS",[_y,_m,_d,_h,_mm]];
	};
};
diag_log(_ret);
_ret
