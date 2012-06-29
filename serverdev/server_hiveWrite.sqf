private ["_args","_mhumanity" , "_mstats" , "_mstate" , "_mhead", "_mhkills", "_mkills" , "_mbkills", "_mmodel", "_mate", "_mdrank", "_msurv","_ret","_params","_do","_counter","_mid","_muid","_mposition","_mtime","_minventory","_mbackpack","_mmedical","_result"];
//diag_log ("Entered hiveWrite with " + _this);
_result = [_this,",","|"] call CBA_fnc_replace;
_result = [_result, ":"] call CBA_fnc_split;
_mid = [_result select 2,"""",""] call CBA_fnc_replace;
_key = _result select 1;
//Player death
switch (_key) do
{
	case "202":{
	"Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','setCD','myid=%1']", _mid];
	};
//Player update
	case "201":{		
	_mposition 	= _result select 3;
	_minventory = _result select 4;
	_mbackpack 	= _result select 5;
	_mmedical 	= _result select 6;
	_mate 		= _result select 7;
	_mdrank 	= _result select 8;
	_mtime 		= _result select 12;
	if(_mate == "false") then {_mate = _mtime;}
	else{_mate = -1;};
	if(_mdrank == "false") then {_mdrank = _mtime;}
	else{_mdrank = -1;};		
	_mmodel 	= _result select 16;
	if(_mmodel=="")then{_mmodel="any"};
	_mhumanity 	= _result select 17;
	if(_mhumanity=="0") then {_mhumanity = 0};
	_mkills 	= _result select 9;
	_mhead 		= _result select 10;
	_mhkills 	= _result select 14;
	_mbkills 	= _result select 15;	
	_mstate 	= _result select 13;
	"Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','update','myid=%1,mypos=%2,myinv=%3,myback=%4,mymed=%5,myate=%6,mydrank=%7,mytime=%8,mymod=%9,myhum=%10,myk=%11,myhs=%12,myhk=%13,mybk=%14,mystate=%15']", _mid,_mposition,_minventory,_mbackpack,_mmedical,_mate,_mdrank,_mtime,_mmodel,_mhumanity,_mkills,_mhead,_mhkills,_mbkills,_mstate];
	};
//OBJECTS
//server_publishObject
//format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance, _class, 0 , _charID, _worldspace, [], [], 0,_uid];
	case "308":{
	_type = _result select 3;
	_owner = _result select 5;
	_pos = _result select 6;
	_uid = _result select 10;
	"Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','insOselI','mytype=%1,myowner=%2,myhealth=[],myhp=0,mypos=%3,myuid=%4,myfuel=0']", _type,_owner,_pos,_uid];
	};
//local_delObj //only for tents?
//format["CHILD:310:%1:",_uid];
	case "310":{
	_uid = _result select 2;
	_uid = [_uid, "."] call CBA_fnc_split;
	_uid = _uid select 0;
	"Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','delO','myuid=%1']",_uid];
	};
//server_updateObject
//format["CHILD:305:%1:%2:%3:",_objectID,_worldspace,fuel _object];
	case "305": {
	_id = _result select 2;
	_pos = _result select 3;
	_fuel = _result select 4;
	if(_fuel=='') then {_fuel=-1};
	"Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','updIPF','myid=%1,mypos=%2,myfuel=%3']",_id,_pos,_fuel];
	};
//format["CHILD:309:%1:%2:",_uid,_inventory];
	case "309":{
	_uid = _result select 2;
	_inventory = _result select 3;
	"Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','updUI','myuid=%1,myinv=%2']", _uid, _inventory];
	};
//format["CHILD:303:%1:%2:",_objectID,_inventory];
	case "303":{
	_id = _result select 2;
	_inventory = _result select 3;
	"Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','updII','myid=%1,myinv=%2']", _id, _inventory];
	};
//format["CHILD:306:%1:%2:%3:",_objectID,_array,damage _object];
	case "306":{
	_id = _result select 2;
	_health = _result select 3;
	_damage = _result select 4;
	if(_damage=='') then {_damage=-1};
	"Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','updIH','myid=%1,myhealth=%2,myhp=%3']", _id, _health, _damage];
	};
//local_createObj //not used
//61-120:format["CHILD:301:%1:%2:%3:%4:%5:%6:%7:%8:",_x, _class, 0 , 0, _worldspace, [], _array, 0];
	case "301": {
	_uid = _result select 2;
	_type = _result select 3;
	_pos = _result select 6;
	_health = _result select 8;
	"Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQL ['dayz','updV','myuid=%1,mytype=%2,mypos=%3,myhealth=%4']",_uid,_type,_pos,_health];
	};
};