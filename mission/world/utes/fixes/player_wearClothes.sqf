// Ensure any clothes worn are in player's gear
if (_this in (magazines player)) then { _this spawn player_wearClothes_orig };
