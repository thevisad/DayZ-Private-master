drop procedure if exists `proc_insertObject`;
create procedure `proc_insertObject`(in `p_uniqueId` varchar(255), in `p_type` varchar(255), in `p_health` varchar(1024), in `p_damage` double, in `p_fuel` double, in `p_owner` int, in `p_position` varchar(255), in `p_instanceId` int)
begin
  insert into objects
    (uid,otype,health,damage,oid,pos,fuel,instance,created)
  values
    (p_uniqueId, p_type, p_health, p_damage, p_owner, p_position, p_fuel, p_instanceId, CURRENT_TIMESTAMP()); --
end;

