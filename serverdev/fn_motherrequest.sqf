private ["_args","_ret","_params","_muid","_mposition","_mbackpack","_minventory","_mmedical","_result","_mid","_msurvival","_mstats","_mstate","_mmodel"];
_ret = [0,0,1]; //default for everything else except defined, works for sp should cause no probs
_args = _this select 0;// retrieve the key
_result = [_args, ":"] call CBA_fnc_split;
if ((_result select 1)=="101") then 
{
	if (_this select 1) then
	{
	// we get the player uid so we retrieve id position backpack inventory medical
		_muid = _result select 2;
		if(_muid=='' || _muid=='false')then{diag_log("ERROR");_ret=["ERROR"];}
		else
		{
			_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','selIPIBMSSS','myuid=%1']", _muid];
			_qresult = [_qresult,"|",","] call CBA_fnc_replace;
			_qresult = call compile _qresult;
			_qresult = _qresult select 0;
			_mid 		= call compile (_qresult select 0);
			_mposition 	= call compile (_qresult select 1);
			_mbackpack 	= call compile (_qresult select 3);
			_minventory = call compile (_qresult select 2);
			_mmedical 	= call compile (_qresult select 4);
			_mtime 		= call compile (_qresult select 5);
			_mstats 	= call compile (_qresult select 6);
			_mstate 	= [_qresult select 7,"[""|","[""""|"] call CBA_fnc_replace;
			_mstate 	= call compile (_mstate);
			_mate = call compile (_qresult select 8);
			_mdrank = call compile _qresult select 9;
			_ret = ["",1,_mid,_mposition,_minventory,_mbackpack,_mmedical,[_mtime,_mate,_mdrank],_mstats,_mstate];
		};
	}
	else
	{
		//on input we get the playerid uid, so we use it to check and if possible return the previous char
		_muid = _result select 2;			
		if(_muid=='' || _muid=='false')then{diag_log("ERROR");_ret=["ERROR"];}
		else
		{
			_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','selIIBSM','myuid=%1']", _muid];
			_qresult = [_qresult,"|",","] call CBA_fnc_replace;
			_qresult = call compile _qresult;
			_qresult = _qresult select 0;
			//If returned array doesnt not contain enough data then its a new char
			if(count _qresult > 1) then
			{
				//Ok we know that this uid has a living char! So return charid , backpack, inventory
				_mid 		= call compile (_qresult select 0);
				_minventory = call compile (_qresult select 1);	
				_mbackpack 	= call compile (_qresult select 2);
				_msurvival 	= call compile (_qresult select 3);
				_mmodel 	= call compile (_qresult select 4);
				// what is this first parameter(response!), second: newplayer
				_ret = ["",1,_mid,0,_minventory,_mbackpack,_msurvival,_mmodel,1];
			} else
			{
				//No character! We add a new char to this uid and retrieve charID
				_name = _result select 4;
				_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','insUNselI','myuid=%1,myname=%2']", _muid, _name];
				_qresult = call compile _qresult;
				_qresult = _qresult select 0;
				_mid = call compile (_qresult select 0);
				_ret = ["",0,_mid];
			};
		};
	};
};
_ret