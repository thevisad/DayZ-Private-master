delete from iv using instance_vehicle iv join world_vehicle wv on iv.world_vehicle_id = wv.id where wv.world_id = 10 and wv.last_modified != '0.34';
delete from world_vehicle where world_id = 10 and last_modified != '0.34';
