// Ensure any eaten items are in player's gear
if (_this in (magazines player)) then { _this spawn player_eat_orig };
