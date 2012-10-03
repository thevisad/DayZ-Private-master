drop procedure if exists `proc_updateObjectInventory`;
create procedure `proc_updateObjectInventory`(in `p_objectId` int, in `p_inventory` varchar(2048))
begin
  update objects set
    inventory = p_inventory
  where
    id = p_objectId; --
end;

