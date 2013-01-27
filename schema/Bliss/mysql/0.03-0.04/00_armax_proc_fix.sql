drop procedure if exists `selIIBSM`;
create procedure `selIIBSM`(in myuid varchar(128))
begin
      select id, inventory, backpack, floor(time_to_sec(timediff(now(),survival))/60), model, late, ldrank from main where uid = myuid and death = 0; --
end;

drop procedure if exists `selIPIBMSSS`;
create procedure `selIPIBMSSS`(in myuid varchar(128))
begin
      select id, pos, inventory, backpack, medical, floor(time_to_sec(timediff(now(),survival))/60), kills, state, late, ldrank, hs, hkills, bkills from main where uid = myuid and death = 0; --
end;

drop procedure if exists `insUNselI`;
create procedure `insUNselI`(in myuid varchar(128), in myname varchar(255))
begin
      insert into main (uid, name,survival) values (myuid, myname, now()); --
      select last_insert_id(); --
end;
