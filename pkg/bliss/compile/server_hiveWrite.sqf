private ["_args","_mhumanity" , "_mmodel", "_mate", "_mdrank", "_mid", "_mtime", "_result","_uid","_fuel","_damage"];

//diag_log ("Entered hiveWrite with " + _this);
_args = _this;
_result = [_args, ":"] call fnc_split;
_mid = [_result select 2,"""",""] call fnc_replace;
_key = _result select 1;

switch (_key) do
{
	case "103":{
		//Save Login/Logout
		diag_log("SAVELOGINOUT:103");
		_action = _result select 4;
		//Logged in
		if (_action == "0") then {
			"blisshive" callExtension format ["E:%1:call proc_logLogin('%2', %3)", (call fnc_instanceName), _result select 2, dayz_instance];
		} else {
			//Logged out
			if (_action == "2") then {
				"blisshive" callExtension format ["E:%1:call proc_logLogout('%2', %3)", (call fnc_instanceName), _result select 2, dayz_instance];
			}
		}	
	};
	case "201":{
		//Player Update
		//diag_log("UPDPLAYER:201");
		_mate 		= _result select 7;
		_mdrank 	= _result select 8;
		_mtime 		= _result select 12;

		if(_mate == "false") then { _mate = _mtime; }
		else{_mate = -1;};

		if(_mdrank == "false") then { _mdrank = _mtime; }
		else{ _mdrank = -1; };

		_mmodel = _result select 16;
		if(_mmodel == "") then { _mmodel = "any" };
		_mhumanity = _result select 17;
		if(_mhumanity == "0") then { _mhumanity = 0 };
		"blisshive" callExtension format ["E:%1:call proc_updateSurvivor(%2, '%3', '%4', '%5', '%6', %7, %8, %9, '%10', %11, %12, %13, %14, %15, '%16')", (call fnc_instanceName), _mid,_result select 3,_result select 4,_result select 5,_result select 6,_mate,_mdrank,_mtime,_mmodel,_mhumanity,_result select 9,_result select 10,_result select 14,_result select 15,_result select 13];
	};
	case "202":{
		//Character Death
		//diag_log("CHARDEATH:202");
		"blisshive" callExtension format ["E:%1:call proc_killSurvivor(%2)", (call fnc_instanceName), _mid];
	};
	case "203":{
		//Player Update
		//diag_log("PLAYERUPDATE:203");
		"blisshive" callExtension format ["E:%1:call proc_updateSurvivor(%2, '[]', '%3', '%4', '[]', -1, -1, 0, 'any', 0, 0, 0, 0, 0, '["""",""aidlpercmstpsnonwnondnon_player_idlesteady04"",36]')", (call fnc_instanceName), _result select 2,_result select 3, _result select 4];
	};
	case "301": {
		//Create Object
		//diag_log("MKOBJ:301");
		//61-120:format["CHILD:301:%1:%2:%3:%4:%5:%6:%7:%8:",_x, _class, 0 , 0, _worldspace, [], _array, 0];
		"blisshive" callExtension format ["E:%1:call proc_updateObject(%2, '%3', '%4', '%5')", (call fnc_instanceName), _result select 2, _result select 3, _result select 6, _result select 8];
	};
	case "304":{
		//Delete Object by ID
		//diag_log("DELOBJID:304");
		//format["CHILD:304:%1:", _objectID];
		"blisshive" callExtension format ["E:%1:call proc_deleteObjectId(%2)", (call fnc_instanceName), _result select 2];
	};
	case "303":{
		//Update Object Inventory (ID)
		//diag_log("OBJINV:303");
		//format["CHILD:303:%1:%2:", _objectID, _inventory];
		"blisshive" callExtension format ["E:%1:call proc_updateObjectInventory(%2, '%3')", (call fnc_instanceName), _result select 2, _result select 3];
	};
	case "305": {
		//Update Object Position and Fuel
		//diag_log("UPDOBJ:305");
		//format["CHILD:305:%1:%2:%3:", _objectID, _worldspace, fuel _object];
		_fuel = _result select 4;
		if(_fuel == '') then { _fuel = -1 };
		"blisshive" callExtension format ["E:%1:call proc_updateObjectPosition(%2, '%3', %4)", (call fnc_instanceName), _result select 2, _result select 3, _fuel];
	};
	case "306":{
		//Update Object Inventory and Health
		//diag_log("UPDIH:306");
		//format["CHILD:306:%1:%2:%3:", _objectID, _array, damage _object];
		_damage = _result select 4;
		if( _damage == '' ) then { _damage = -1 };
		"blisshive" callExtension format ["E:%1:call proc_updateObjectHealth(%2, '%3', %4)", (call fnc_instanceName), _result select 2, _result select 3, _damage];
	};
	case "308":{
		//Publish Object
		//diag_log("PUBOBJ:308");
		//format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance, _class, 0 , _charID, _worldspace, [], [], 0,_uid];
		"blisshive" callExtension format ["E:%1:call proc_insertObject('%2', '%3', '[]', 0, 0, %4, '%5', %6)", (call fnc_instanceName), _result select 10,_result select 3,_result select 5,_result select 6,dayz_instance];
	};
	case "309":{
		//Update Object Inventory (UID)
		//diag_log("OBJINVU:309");
		//format["CHILD:309:%1:%2:", _uid, _inventory];
		"blisshive" callExtension format ["E:%1:call proc_updateObjectInventoryByUID('%2', '%3')", (call fnc_instanceName), _result select 2, _result select 3];
	};
	case "310":{
		//Delete Object
		//diag_log("DELOBJ:310");
		//format["CHILD:310:%1:",_uid];
		"blisshive" callExtension format ["E:%1:call proc_deleteObject('%2')", (call fnc_instanceName), _result select 2];
	};
};
