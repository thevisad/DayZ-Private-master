create table if not exists building (
  id smallint unsigned not null auto_increment,
  class_name varchar(100) default null,

  primary key pk_building (id),
  unique key uq1_building (class_name)
) character set utf8 engine=InnoDB;

