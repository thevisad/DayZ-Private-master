drop procedure if exists `proc_getObjectPageCount`;
create procedure `proc_getObjectPageCount`(in `p_instanceId` int)
begin
  declare itemsPerPage int default 5; -- must match proc_getobjects
  select floor(count(*) / itemsPerPage) + if((count(*) mod itemsPerPage) > 0, 1, 0) from objects where instance = p_instanceId; --
end;

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

drop procedure if exists `proc_getSchedulerTasks`;
create procedure `proc_getSchedulerTasks`(in `p_instanceId` int, in `p_currentPage` int)
begin
  set @instance = p_instanceId; --
  set @page = greatest(((p_currentPage - 1) * 10), 0); --
  prepare stmt from 'select message,mtype,looptime,mstart from scheduler s join instances i on i.mvisibility = s.visibility where i.instance = ? limit ?, 10'; --
  execute stmt using @instance, @page; -- 
  deallocate prepare stmt; --
end;

drop procedure if exists `proc_getObjects`;
create procedure `proc_getObjects`(in `p_instanceId` int, in `p_currentPage` int)
begin
  set @instance = p_instanceId; --
  set @page = greatest(((p_currentPage - 1) * 5), 0); --
  prepare stmt from 'select id,otype,oid,pos,inventory,health,fuel,damage from objects where instance = ? limit ?, 5'; --
  execute stmt using @instance, @page; --
  deallocate prepare stmt; --
end;

delete from objects where health like '["%';
