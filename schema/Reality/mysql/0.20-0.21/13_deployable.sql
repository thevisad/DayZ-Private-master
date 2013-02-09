create table if not exists deployable (
  id smallint unsigned not null auto_increment,
  class_name varchar(100) default null,

  primary key pk_deployable (id),
  unique key uq1_deployable (class_name)
) character set utf8 engine=InnoDB;

insert ignore into deployable (class_name) values
  ('TentStorage'),
  ('TrapBear'),
  ('Wire_cat1'),
  ('Hedgehog_DZ'),
  ('Sandbag1_DZ'); 
