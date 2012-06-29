private ["_args","_ret","_params","_mstats","_mmodel","_mhumanity","_mstate","_muid","_name","_qresult","_result","_newPlayer","_mmedical","_mposition","_mid","_minventory","_mbackpack","_msurvival"];
_args = _this select 0;// get the key
_ret = [];//reset ret for other unimplemented calls
_result = [_args, ":"] call CBA_fnc_split;
// get uid from input
_muid = _result select 2;
_key = _result select 1;
switch (_key) do
{
	case "102":{
		if(_muid=='' || _muid=='false')then
		{
			diag_log("ERROR");_ret=["ERROR"];
		}else{
			_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','selMPSSH','myid=%1']", _muid];
			_qresult = [_qresult,"|",","] call CBA_fnc_replace;
			_qresult = call compile _qresult;
			_qresult = _qresult select 0;
			diag_log ("CHILD:102 - Player setup for Character with ID = "+_mid);
			_mmedical 	= call compile (_qresult select 0);
			_mposition 	= call compile (_qresult select 1);
			_mkills 	= call compile (_qresult select 2);
			_mstate 	= _qresult select 3;
			_mstate 	= [_mstate,"["",","["""","] call CBA_fnc_replace; //ugly fix for character escaping bug
			_mstate 	= call compile (_mstate);
			_mhumanity 	= call compile (_qresult select 4);
			_mhs 		= call compile (_qresult select 5);
			_mhk 		= call compile (_qresult select 6);
			_mbk 		= call compile (_qresult select 7);
			_ret = ["",_mmedical,[_mkills,_mhs,_mhk,_mbk],_mstate,_mposition,_mhumanity];
		};
	};
	case "101": {
		if(_muid=='' || _muid=='false')then{diag_log("ERROR");_ret=["ERROR"];}
		else
		{
		_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','selIIBSM','myuid=%1']", _muid];
		_qresult = [_qresult,"|",","] call CBA_fnc_replace;
		_qresult = call compile _qresult;
		//if _qresult is not null then we have a returning player else someone new has joined
		_newPlayer = count _qresult<1;
		diag_log ("CHILD:101 - Player Login for UID = "+_muid + " IsNew? "+str(_newPlayer)+"!");	
		if (_newPlayer) then
		{
				// A new uid! Great we have to create a new entry and char
				_name = _result select 4;
				_qresult = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','insUNselI','myuid=%1,myname=%2']", _muid, _name];
				_qresult = call compile _qresult;
				_qresult = _qresult select 0 ;	
				//return char id once created!
				_mid = _qresult select 0;
				_ret = ["",true,_mid,"Survivor2_DZ",dayz_hiveVersionNo];
		}else{
			//if we know this player then we return inventory and backpack
				_qresult 	= _qresult select 0;
				_mid 		= _qresult select 0;
				_mbackpack 	= call compile (_qresult select 2);
				_minventory = call compile (_qresult select 1);
				_mtime 		= call compile (_qresult select 3);
				_mmodel 	= call compile (_qresult select 4);
				_mate 		= call compile (_qresult select 5);
				_mdrank 	= call compile (_qresult select 6);
				_ret = ["",false,_mid,[],_minventory,_mbackpack,[_mtime,_mate,_mdrank],_mmodel,dayz_hiveVersionNo];
			};
		};
	};
};
_ret