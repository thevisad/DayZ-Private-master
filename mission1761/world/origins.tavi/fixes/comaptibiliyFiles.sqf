 if(isServer) then {
 "dayzOrigingsL2" addPublicVariableEventHandler {(_this select 1) call server_playerSetup};
 "DOdowndblink"   addPublicVariableEventHandler {_id = (_this select 1) spawn server_playerLogin};
 "DOgNo_Se"    addPublicVariableEventHandler {_id = (_this select 1) call server_playerSync};
 };