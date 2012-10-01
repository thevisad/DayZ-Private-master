// Ensure any items subject to the cook action are in player's gear
if (_this in (magazines player)) then { _this spawn player_cook_orig };
