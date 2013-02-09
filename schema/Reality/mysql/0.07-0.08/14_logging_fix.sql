alter table log_entry
  add column instance_id int(11) unsigned not null default 0,
  change profile_id unique_id varchar(128) not null default '';
