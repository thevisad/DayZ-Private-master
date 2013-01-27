create table if not exists instance_building (
  id bigint unsigned not null auto_increment,
  building_id smallint unsigned not null,
  instance_id bigint unsigned not null default 1,
  worldspace varchar(60) not null default '[0,[0,0,0]]',
  created timestamp not null default '0000-00-00 00:00:00',

  primary key pk_instance_building (id),
  index idx1_instance_building (building_id),
  index idx3_instance_building (instance_id),
  foreign key fk1_instance_building (instance_id) references instance (id),
  foreign key fk3_instance_building (building_id) references building (id)
) character set utf8 engine=InnoDB;

