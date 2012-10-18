// Ensure any unfilled water bottles are in player's gear
if (_this in (magazines player)) then { _this spawn player_fillWater_orig };
