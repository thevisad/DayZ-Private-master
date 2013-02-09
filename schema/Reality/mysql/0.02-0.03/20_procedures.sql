drop procedure if exists `getO`;
create procedure `getO`(in myinstance int, in page int)
begin
  set @i = myinstance; -- 
  set @s = 5; -- 
  set @p = (page * @s); -- 
  prepare stmt1 from 'SELECT id,otype,oid,pos,inventory,health,fuel,damage FROM objects WHERE instance=? LIMIT ?, ?'; -- 
  execute stmt1 using @i,@p,@s; -- 
  deallocate prepare stmt1; -- 
end;

drop procedure if exists `getTasks`;
create procedure `getTasks`(in myinstance int, in page int)
begin
  set @i = myinstance; -- 
  set @s = 10; -- 
  set @p = (page * @s); -- 
  prepare stmt1 from 'SELECT message,mtype,looptime,mstart FROM scheduler JOIN instances ON mvisibility=visibility WHERE instance=? LIMIT ?, ?'; -- 
  execute stmt1 using @i,@p,@s; -- 
  deallocate prepare stmt1; -- 
end;

drop procedure if exists `getTC`;
create procedure `getTC`(in myinstance int)
begin
  select floor(count(*) / 10) from scheduler join instances on mvisibility = visibility where instance = myinstance; -- 
end;

drop procedure if exists `getOC`;
create procedure `getOC`(in myinstance int)
begin
  select floor(count(*) / 5) from objects where instance = myinstance; -- 
end;

drop procedure if exists `updUI`;
create procedure `updUI`(in myuid varchar(50), in myinv varchar(2048))
begin
  update objects set inventory = myinv where uid not like '%.%' and convert(uid, unsigned integer) between (convert(myuid, unsigned integer) - 2) and (convert(myuid, unsigned integer) + 2); -- 
end;
