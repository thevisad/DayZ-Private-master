private ["_args","_ret","_muid","_result"];
_ret = [0,0,1]; //default for everything else except defined, works for sp should cause no probs
_args = _this select 0;// retrieve the key
_result = [_args, ":"] call CBA_fnc_split;
if ((_result select 1)=="101") then 
{
diag_log("MOTHER");
	if (_this select 1) then
	{
	// we get the player uid so we retrieve id position backpack inventory medical
		_muid = _result select 2;
			_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','selIPIBMSSS','myuid=%1']", _muid];
			_qresult = [_qresult,"|",","] call CBA_fnc_replace;
			_qresult = call compile _qresult;
			_qresult = _qresult select 0;
			_ret = ["",1,call compile (_qresult select 0),call compile (_qresult select 1),call compile (_qresult select 2),call compile (_qresult select 3),call compile (_qresult select 4),[call compile (_qresult select 5),call compile (_qresult select 8),call compile (_qresult select 9)],[call compile (_qresult select 6),call compile (_qresult select 10),call compile (_qresult select 11),call compile (_qresult select 12)],call compile ([_qresult select 7,"[""|","[""""|"] call CBA_fnc_replace)];
	}
	else
	{
		//on input we get the playerid uid, so we use it to check and if possible return the previous char
		_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','selIIBSM','myuid=%1']", _result select 2];
		_qresult = [_qresult,"|",","] call CBA_fnc_replace;
		_qresult = call compile _qresult;
		_qresult = _qresult select 0;
		//If returned array doesnt not contain enough data then its a new char
		if(count _qresult > 1) then
		{
			//Ok we know that this uid has a living char! So return charid , backpack, inventory
			// what is this first parameter(response!), second: newplayer
			_ret = ["",1,call compile (_qresult select 0),0,call compile (_qresult select 1),call compile (_qresult select 2),[call compile (_qresult select 3),call compile (_qresult select 5),call compile (_qresult select 6)],call compile (_qresult select 4),dayz_hiveVersionNo];
		} else
		{
			//No character! We add a new char to this uid and retrieve charID
			_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','insUNselI','myuid=%1,myname=%2']", _result select 2, _result select 4];
			_qresult = call compile _qresult;
			_qresult = _qresult select 0;
			_ret = ["",0,call compile (_qresult select 0)];
		};
	};
};
diag_log(_ret);
_ret