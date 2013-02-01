create table if not exists instance_vehicle (
  id bigint unsigned not null auto_increment,
  vehicle_id smallint unsigned not null,
  instance_id bigint unsigned not null default 1,
  worldspace varchar(60) not null default '[0,[0,0,0]]',
  inventory varchar(2048) not null default '[]',
  parts varchar(1024) not null default '[]',
  fuel double not null default 0,
  damage double not null default 0,
  last_updated timestamp not null default current_timestamp on update current_timestamp,
  created timestamp not null default '0000-00-00 00:00:00',

  primary key pk_instance_vehicle (id),
  index idx1_instance_vehicle (vehicle_id),
  index idx3_instance_vehicle (instance_id),
  foreign key fk1_instance_vehicle (instance_id) references instance (id),
  foreign key fk2_instance_vehicle (vehicle_id) references vehicle (id)
) character set utf8 engine=InnoDB;

insert ignore into instance_vehicle (
  select
    o.id id,
    v.id vehicle_id,
    o.instance instance_id,
    o.pos worldspace,
    o.inventory,
    o.health parts,
    o.fuel,
    o.damage,
    o.lastupdate last_updated,
    o.created
  from
    objects o
    inner join vehicle v on o.otype = v.class_name
  where
    o.oid = 0
);
