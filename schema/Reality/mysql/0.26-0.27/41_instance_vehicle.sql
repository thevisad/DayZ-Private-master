alter table instance_vehicle add column world_vehicle_id bigint unsigned default null after vehicle_id;

update instance_vehicle iv join world_vehicle wv on iv.worldspace = wv.worldspace set iv.world_vehicle_id = wv.id;
delete from instance_vehicle where world_vehicle_id is null;

alter table instance_vehicle
  modify world_vehicle_id bigint unsigned not null after vehicle_id,
  add constraint fk3_instance_vehicle foreign key (world_vehicle_id) references world_vehicle (id);

alter table instance_vehicle
  drop foreign key instance_vehicle_ibfk_2,
  drop index idx1_instance_vehicle,
  drop column vehicle_id;
