drop procedure if exists `proc_updateObjectInventory`;
create procedure `proc_updateObjectInventory`(in `p_objectId` int, in `p_inventory` varchar(2048))
begin
  update objects set
    inventory = p_inventory
  where
    id = p_objectId; --
end;

drop procedure if exists `proc_getObjectPageCount`;
create procedure `proc_getObjectPageCount`(in `p_instanceId` int)
begin
  declare itemsPerPage int default 10; -- must match proc_getObjects
  select floor(count(*) / itemsPerPage) + if((count(*) mod itemsPerPage) > 0, 1, 0) from objects where instance = p_instanceId; --
end;

drop procedure if exists `proc_getObjects`;
create procedure `proc_getObjects`(in `p_instanceId` int, in `p_currentPage` int)
begin
  set @instance = p_instanceId; --
  set @page = greatest(((p_currentPage - 1) * 10), 0); -- must match proc_getObjectPageCount
  prepare stmt from 'select id,otype,oid,pos,inventory,health,fuel,damage from objects where instance = ? limit ?, 10'; --
  execute stmt using @instance, @page; --
  deallocate prepare stmt; --
end;

