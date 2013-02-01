create table if not exists message (
  id smallint not null auto_increment,
  payload varchar(1024) not null,
  loop_interval int unsigned not null default 0,
  start_delay int unsigned not null default 30,
  instance_id bigint unsigned default null,

  primary key pk_message (id),
  foreign key fk1_message (instance_id) references instance (id)
) character set utf8 engine=InnoDB;
