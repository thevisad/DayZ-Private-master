//diag_log ("Spawned: " + str([_type, _position, [], _radius, _method]));
 _agent = createAgent [_type, _position, [], _radius, _method];
+dayzSpawnZed = [_agent];
+publicVariableServer "dayzSpawnZed";
 if (_doLoiter) then {
   _agent setPosATL _position;
   //_agent setVariable ["doLoiter",true,true];