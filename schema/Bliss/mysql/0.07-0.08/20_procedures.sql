drop procedure if exists `getTime`;
drop procedure if exists `proc_getInstanceTime`;
create procedure `proc_getInstanceTime`(in `p_instanceId` int)
begin
  declare server_time datetime default now(); --
  select now() + interval (offset) hour into server_time from instances where instance = p_instanceid; --
  select date_format(server_time,'%d-%m-%y'), time_format(server_time, '%T'); --
end;

drop procedure if exists `getLoadout`;
drop procedure if exists `proc_getInstanceLoadout`;
create procedure `proc_getInstanceLoadout`(in `p_instanceId` int)
begin
  select loadout from instances where instance = p_instanceId; --
end;

drop procedure if exists `getO`;
drop procedure if exists `proc_getObjects`;
create procedure `proc_getObjects`(in `p_instanceId` int, in `p_currentPage` int)
begin
  set @instance = p_instanceId; --
  set @page = greatest(((p_currentPage - 1) * 5), 0); --
  prepare stmt from 'select id,otype,oid,pos,inventory,health,fuel,damage from objects where instance = ? limit ?, 5'; --
  execute stmt using @instance, @page; --
  deallocate prepare stmt; --
end;

drop procedure if exists `getOC`;
drop procedure if exists `proc_getObjectPageCount`;
create procedure `proc_getObjectPageCount`(in `p_instanceId` int)
begin
  declare itemsPerPage int default 5; -- must match proc_getobjects
  select floor(count(*) / itemsPerPage) + if((count(*) mod itemsPerPage) > 0, 1, 0) from objects where instance = p_instanceId; --
end;

drop procedure if exists `getTasks`;
drop procedure if exists `proc_getSchedulerTasks`;
create procedure `proc_getSchedulerTasks`(in `p_instanceId` int, in `p_currentPage` int)
begin
  set @instance = p_instanceId; --
  set @page = greatest((p_currentPage - 1) * 10, 0); --
  prepare stmt from 'select message,mtype,looptime,mstart from scheduler s join instances i on i.mvisibility = s.visibility where i.instance = ? limit ?, 10'; --
  execute stmt using @instance, @page; -- 
  deallocate prepare stmt; --
end;

drop procedure if exists `getTC`;
drop procedure if exists `proc_getSchedulerTaskPageCount`;
create procedure `proc_getSchedulerTaskPageCount`(in `p_instanceId` int)
begin
  declare itemsPerPage int default 10; -- must match proc_getschedulertasks
  select
    floor(count(*) / itemsPerPage) + if((count(*) mod itemsPerPage) > 0, 1, 0)
  from
    scheduler
    join instances on instances.mvisibility = scheduler.visibility
  where
    instances.instance = p_instanceId; --
end;

drop procedure if exists `insUNselI`;
drop procedure if exists `proc_insertSurvivor`;
create procedure `proc_insertSurvivor`(in `p_uniqueId` varchar(128), in `p_playerName` varchar(255))
begin
  insert into profile
    (unique_id, name)
  values
    (p_uniqueId, p_playerName)
  on duplicate key update name = p_playerName; --
  insert into survivor
    (unique_id, start_time)
  values
    (p_uniqueId, now()); --
  select last_insert_id(); --
end;


drop procedure if exists `loglogin`;
drop procedure if exists `proc_logLogin`;
create procedure `proc_loglogin`(in `p_uniqueId` varchar(128), in `p_instanceId` int)
begin
  insert into log_entry (unique_id, instance_id, log_code_id) values (p_uniqueId, p_instanceId, 1); --
end;


drop procedure if exists `loglogout`;
drop procedure if exists `proc_logLogout`;
create procedure `proc_loglogout`(in `p_uniqueId` varchar(128), in `p_instanceId` int)
begin
  insert into log_entry (unique_id, instance_id, log_code_id) values (p_uniqueId, p_instanceId, 2); --
end;


drop procedure if exists `selIIBSM`;
drop procedure if exists `proc_loginSurvivor`;
create procedure `proc_loginSurvivor`(in `p_uniqueId` varchar(128), in `p_playerName` varchar(128))
begin 
  update profile set name = p_playerName where unique_id = p_uniqueId; --
  select
    id, inventory, backpack, floor(time_to_sec(timediff(now(), start_time)) / 60), model, last_ate, last_drank
  from survivor
  where
    survivor.unique_id = p_uniqueId
    and is_dead = 0; --
end;


drop procedure if exists `selMPSSH`;
drop procedure if exists `proc_getSurvivorStats`;
create procedure `proc_getSurvivorStats`(in `p_survivorId` int)
begin
  select
    medical, pos, zombie_kills, state, p.humanity, headshots, survivor_kills, bandit_kills
  from
    survivor s
    inner join profile p on s.unique_id = p.unique_id
  where
    s.id = p_survivorId
    and s.is_dead = 0; --
end;


drop procedure if exists `setCD`;
drop procedure if exists `proc_killSurvivor`;
create procedure `proc_killSurvivor`(in `p_survivorId` int)
begin
  update survivor set is_dead = 1 where id = p_survivorId; --
  update
    profile
    left join survivor on survivor.unique_id = profile.unique_id
  set
    survival_attempts=survival_attempts+1,
    total_survivor_kills=total_survivor_kills+survivor_kills,
    total_bandit_kills=total_bandit_kills+bandit_kills,
    total_zombie_kills=total_zombie_kills+zombie_kills,
    total_headshots=total_headshots+headshots,
    total_survival_time=total_survival_time+survival_time
  where
    survivor.id = p_survivorId; --
end;

drop procedure if exists `update`;
drop procedure if exists `proc_updateSurvivor`;
create procedure `proc_updateSurvivor`(in `p_survivorId` int, in `p_position` varchar(1024), in `p_inventory` varchar(2048), in `p_backpack` varchar(2048), in `p_medical` varchar(1024), in `p_lastAte` int, in `p_lastDrank` int, in `p_survivalTime` int, in `p_model` varchar(255), in `p_humanity` int, in `p_zombieKills` int, in `p_headshots` int, in `p_murders` int, in `p_banditKills` int, in `p_state` varchar(255))
begin
  update
    profile p
    inner join survivor s on s.unique_id = p.unique_id
  set
    p.humanity = if(p_humanity = 0, humanity, p_humanity)
  where
    s.id = p_survivorId; --

  update survivor set
    zombie_kills = zombie_kills + p_zombieKills,
    headshots = headshots + p_headshots,
    bandit_kills = bandit_kills + p_banditKills,
    survivor_kills = survivor_kills + p_murders,
    state = p_state,
    model = if(p_model = 'any', model, p_model),
    last_ate = if(p_lastAte = -1, 0, last_ate + p_lastAte),
    last_drank = if(p_lastDrank < -1, 0, last_drank + p_lastDrank),
    survival_time = survival_time + p_survivalTime,
    pos = if(p_position = '[]', pos, p_position),
    medical = if(p_medical = '[]', medical, p_medical),
    backpack = if(p_backpack='[]', backpack, p_backpack),
    inventory = if(p_inventory='[]', inventory, p_inventory)
  where
    id = p_survivorId; --
end;

drop procedure if exists `insOselI`;
drop procedure if exists `proc_insertObject`;
create procedure `proc_insertObject`(in `p_uniqueId` varchar(255), in `p_type` varchar(255), in `p_health` varchar(1024), in `p_damage` double, in `p_fuel` double, in `p_owner` int, in `p_position` varchar(255), in `p_instanceId` int)
begin
  insert into objects
    (uid,otype,health,damage,oid,pos,fuel,instance)
  values
    (p_uniqueId, p_type, p_health, p_damage, p_owner, p_position, p_fuel, p_instanceId); --
end;

drop procedure if exists `delO`;
drop procedure if exists `proc_deleteObject`;
create procedure `proc_deleteObject`(in `p_uniqueId` varchar(128))
begin
  delete from objects where uid = p_uniqueid; --
end;

drop procedure if exists `updV`;
drop procedure if exists `proc_updateObject`;
create procedure `proc_updateObject`(in `p_uniqueId` varchar(128), in `p_type` varchar(255) , in `p_position` varchar(255), in `p_health` varchar(1024))
begin
  update objects set
    otype = if(p_type = '', otype, p_type),
    health = p_health,
    pos = if(p_position = '[]', pos, p_position)
  where
    uid = p_uniqueId; --
end;

drop procedure if exists `updII`;
drop procedure if exists `proc_updateObjectInventory`;
create procedure `proc_updateObjectInventory`(in `p_objectId` int, in `p_inventory` varchar(1024))
begin
  update objects set
    inventory = p_inventory
  where
    id = p_objectId; --
end;

drop procedure if exists `updIPF`;
drop procedure if exists `proc_updateObjectPosition`;
create procedure `proc_updateObjectPosition`(in `p_objectId` int, in `p_position` varchar(255), in `p_fuel` double)
begin
  update objects set
    pos = if(p_position = '[]', pos, p_position),
    fuel = p_fuel
  where
    id = p_objectId; --
end;

drop procedure if exists `updIH`;
drop procedure if exists `proc_updateObjectHealth`;
create procedure `proc_updateObjectHealth`(in `p_objectId` int, in `p_health` varchar(1024), in `p_damage` double)
begin
  update objects set
    health = p_health,
    damage = p_damage
  where
    id = p_objectId; --
end;

drop procedure if exists `updUI`;
drop procedure if exists `proc_updateObjectInventoryByUID`;
create procedure `proc_updateObjectInventoryByUID`(in `p_uniqueId` varchar(128), in `p_inventory` varchar(8192))
begin
  update objects set
    inventory = p_inventory
  where
    uid not like '%.%'
    and (convert(uid, unsigned integer) between (convert(p_uniqueId, unsigned integer) - 2) and (convert(p_uniqueId, unsigned integer) + 2)); --
end;

drop procedure if exists `selIPIBMSSS`;
