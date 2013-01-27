drop procedure if exists `proc_checkWhitelist`;
create procedure `proc_checkWhitelist`(in p_instanceId int, in p_uniqueId varchar(128))
begin
  select
    if(i.whitelist = 1, coalesce(is_whitelisted, 0), 1)
  from
    instances i
    left join profile p on p.unique_id = p_uniqueId
  where
    i.instance = p_instanceId; --
end;
