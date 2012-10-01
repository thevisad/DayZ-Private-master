// Ensure any items subject to the drink action are in player's gear
if (_this in (magazines player)) then { _this spawn player_drink_orig };
