create table if not exists instance_deployable (
  id bigint unsigned not null auto_increment,
  unique_id varchar(60) not null,
  deployable_id smallint unsigned not null,
  owner_id int unsigned not null,
  instance_id bigint unsigned not null default 1,
  worldspace varchar(60) not null default '[0,[0,0,0]]',
  inventory varchar(2048) not null default '[]',
  last_updated timestamp not null default current_timestamp on update current_timestamp,
  created timestamp not null default '0000-00-00 00:00:00',

  primary key pk_instance_deployable (id),
  index idx1_instance_deployable (deployable_id),
  index idx2_instance_deployable (owner_id),
  index idx3_instance_deployable (instance_id),
  foreign key fk1_instance_deployable (instance_id) references instance (id),
  foreign key fk2_instance_deployable (owner_id) references survivor (id),
  foreign key fk3_instance_deployable (deployable_id) references deployable (id)
) character set utf8 engine=InnoDB;

insert ignore into instance_deployable (
  select
    o.id id,
    o.uid unique_id,
    d.id deployable_id,
    s.id owner_id,
    o.instance instance_id,
    o.pos worldspace,
    o.inventory,
    o.lastupdate last_updated,
    o.created
  from
    objects o
    inner join survivor s on o.oid = s.id
    inner join deployable d on d.class_name = o.otype
  where
    o.oid != 0
);
