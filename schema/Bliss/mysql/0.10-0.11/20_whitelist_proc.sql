drop procedure if exists `proc_checkWhitelist`;
create procedure `proc_checkWhitelist`(in p_instanceId int, in p_uniqueId varchar(128))
begin
  select
    if(i.whitelist = 1, is_whitelisted, 1)
  from
    profile p
    join instances i on i.instance = p_instanceId
  where
    p.unique_id = p_uniqueId; --
end;
