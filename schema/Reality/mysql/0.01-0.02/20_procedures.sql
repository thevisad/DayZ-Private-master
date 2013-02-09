drop procedure if exists `logLogin`;
create procedure `logLogin`(in unique_id varchar(50))
begin
  insert into
    log_entry (profile_id, log_code_id)
  values (unique_id, 1); --
end;

drop procedure if exists `logLogout`;
create procedure `logLogout`(in unique_id varchar(50))
begin
  insert into
    log_entry (profile_id, log_code_id)
  values (unique_id, 2); --
end;
