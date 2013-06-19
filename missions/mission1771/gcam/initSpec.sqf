/*
	title: Administrator Checking
	author: Pwnoz0r
	description: Check if the user executing the script is logged into the server as an administrator.
	usage: This should be executed in "init.sqf" as: execVM "initSpec.sqf";
		This also coincides with the "config.hpp" within the "gcam" folder. You are going to need to place your UID inside of it.
		The "config.hpp" is a double checking system, so that if the user is logged in as admin, but doesn't have their UID inserted it will NOT allow them
			to use the script.
	version: 1.3
*/
spawn_move = 0;
dayz_admin = 0;

while {true} do{
    if (serverCommandAvailable "#kick") then{
	    if (dayz_admin == 0) then{
			dayz_admin = 1;
			spawn_move = 1;
			player enableSimulation true;
			execvm "initSpecKey.sqf";
		};
	};
	sleep 0.1;    
};