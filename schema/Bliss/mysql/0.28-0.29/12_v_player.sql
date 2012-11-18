create or replace view v_player as
  select
     p.name player_name,
     p.humanity,
     s.id alive_survivor_id,
     s.world_id alive_survivor_world_id
  from
    profile p
    left join survivor s on p.unique_id = s.unique_id and s.is_dead = 0;
