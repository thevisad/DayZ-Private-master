create table if not exists instance (
  id bigint unsigned not null auto_increment,
  world_id smallint unsigned not null default 1, 
  tz_offset tinyint not null default 0,
  inventory varchar(2048) not null default '[]',

  primary key pk_instance (id),
  foreign key fk1_instance (world_id) references world (id)
) character set utf8 engine=InnoDB;

insert ignore into instance (
  select
    i.instance,
    coalesce(w.id, 1) world_id,
    i.offset tz_offset,
    i.loadout inventory
  from
    instances i
    left join objects o on i.instance = o.instance
    left join spawns s on o.uid = s.uuid
    left join world w on s.world = w.name
);
