create or replace view v_vehicle as
  select
    iv.id instance_vehicle_id,
    v.id  vehicle_id,
    iv.instance_id instance_id,
    i.world_id,
    v.class_name,
    iv.worldspace,
    iv.inventory,
    iv.parts,
    iv.damage,
    iv.fuel
  from
    instance_vehicle iv
    join world_vehicle wv on iv.world_vehicle_id = wv.id
    join vehicle v on wv.vehicle_id = v.id
    join instance i on iv.instance_id = i.id;
