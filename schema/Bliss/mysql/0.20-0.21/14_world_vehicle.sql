create table if not exists world_vehicle (
  id bigint unsigned not null auto_increment,
  vehicle_id smallint unsigned not null default 1,
  world_id smallint unsigned not null default 1,
  worldspace varchar(60) not null default '[]',
  description varchar(1024) null default null,
  chance decimal(4,3) unsigned not null default 0,
  last_modified varchar(10) null default null,

  primary key pk_world_vehicle (id),
  index idx1_world_vehicle (vehicle_id),
  index idx2_world_vehicle (world_id),
  foreign key fk1_world_vehicle (vehicle_id) references vehicle (id),
  foreign key fk2_world_vehicle (world_id) references world (id)
) character set utf8 engine=InnoDB;

insert ignore into world_vehicle (
  select
    s.id,
    v.id vehicle_id,
    w.id world_id,
    s.pos worldspace,
    s.description,
    s.chance,
    s.last_modified
  from
    spawns s
    join world w on s.world = w.name
    join vehicle v on s.otype = v.class_name
);

