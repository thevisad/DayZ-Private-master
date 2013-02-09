delete from wv
  using
    world_vehicle wv
  join (select
    max(wv.id) id
  from
    world_vehicle wv
  group by
    worldspace
  having
    count(*) > 1) wv2 on wv.id = wv2.id;

update vehicle set inventory = replace(inventory, 'HandGrenade_east', 'HandGrenade_west');
