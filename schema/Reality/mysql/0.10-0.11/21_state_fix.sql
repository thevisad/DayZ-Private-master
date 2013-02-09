drop procedure if exists `proc_loginSurvivor`;
create procedure `proc_loginSurvivor`(in `p_uniqueId` varchar(128), in `p_playerName` varchar(128))
begin 
  update profile set name = p_playerName where unique_id = p_uniqueId; --
  update survivor set state = '["","aidlpercmstpsnonwnondnon_player_idlesteady04",36]' where unique_id = p_uniqueId and state like '%_driver"' or state like '%_pilot"'; --
  select
    id, inventory, backpack, floor(time_to_sec(timediff(now(), start_time)) / 60), model, last_ate, last_drank
  from survivor
  where
    survivor.unique_id = p_uniqueId
    and is_dead = 0; --
end;

