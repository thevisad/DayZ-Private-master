drop procedure if exists `proc_getBuildings`;
create procedure `proc_getBuildings`(in `p_instanceId` int, in `p_currentPage` int)
begin
  set @instance = p_instanceId; --
  set @page = greatest(((p_currentPage - 1) * 5), 0); --
  prepare stmt from '
  select
    b.class_name, ib.worldspace
  from
    instance_building ib
    inner join building b on ib.building_id = b.id
  where
    ib.instance_id = ?
  limit ?, 5'; --
  execute stmt using @instance, @page; --
  deallocate prepare stmt; --
end;

drop procedure if exists `proc_getBuildingPageCount`;
create procedure `proc_getBuildingPageCount`(in `p_instanceId` int)
begin
  declare itemsPerPage int default 5; -- must match proc_getobjects
  select
    floor(count(*) / itemsPerPage) + if((count(*) mod itemsPerPage) > 0, 1, 0)
  from instance_building
  where instance_id = p_instanceId; --
end;


