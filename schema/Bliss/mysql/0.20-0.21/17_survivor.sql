alter table survivor
  add column world_id smallint unsigned not null default 1 after unique_id,
  change pos worldspace varchar(60) not null default '[]' after world_id,
  modify is_dead tinyint unsigned not null default 0 after medical,
  change last_update last_updated timestamp not null default current_timestamp on update current_timestamp after survival_time;

update
  survivor s
  inner join instance i on i.id = 1
set
  s.world_id = i.world_id;
