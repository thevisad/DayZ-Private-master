create procedure `proc_getMessagePageCount`(in `p_instanceId` int)
begin
  declare itemsPerPage int default 10; -- must match proc_getMessagePage
  select
    floor(count(*) / itemsPerPage) + if((count(*) mod itemsPerPage) > 0, 1, 0)
  from message
  where message.instance_id = p_instanceId; --
end;

create procedure `proc_getMessagePage`(in `p_instanceId` int, in `p_currentPage` int)
begin
  set @instance = p_instanceId; --
  set @page = greatest(((p_currentPage - 1) * 10), 0); --
  prepare stmt from 'select payload, loop_interval, start_delay  from message where instance_id = ? limit ?, 10'; --
  execute stmt using @instance, @page; -- 
  deallocate prepare stmt; --
end;

