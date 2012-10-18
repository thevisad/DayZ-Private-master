// Ensure any medication used is in player's gear
if (_this in (magazines player)) then { _this spawn player_useMeds_orig };
