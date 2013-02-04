alter table profile
  add column is_whitelisted tinyint(1) unsigned not null default 0,
  add index idx2_profile (is_whitelisted);

update
  profile p
  join whitelist w on p.unique_id = w.uid
set
  p.is_whitelisted = 1;

drop table whitelist;

alter table instances
  change reserved whitelist tinyint(1) unsigned not null default 0;
