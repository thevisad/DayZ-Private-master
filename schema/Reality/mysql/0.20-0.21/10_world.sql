create table if not exists world (
  id smallint unsigned not null auto_increment,
  name varchar(32) not null default '0',
  max_x mediumint default '0',
  max_y mediumint default '0',

  primary key pk_world (id),
  unique key uq_world (name),
  index idx1_world (name)
) character set utf8 engine=InnoDB;

insert ignore into world
  (name, max_x, max_y)
values
  ('chernarus', 14700, 15360),
  ('lingor', 10000, 10000),
  ('utes', 0, 0),
  ('takistan', 0, 0),
  ('panthera2', 0, 0);
