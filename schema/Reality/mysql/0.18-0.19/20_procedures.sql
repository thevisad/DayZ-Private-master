drop procedure if exists `proc_deleteObjectId`;
create procedure `proc_deleteObjectId`(in `p_objectId` int(11))
begin
  delete from objects where id = p_objectId; --
end;

