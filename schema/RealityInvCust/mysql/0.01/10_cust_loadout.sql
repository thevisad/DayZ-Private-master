create table if not exists cust_loadout (
  id bigint unsigned not null auto_increment,
  inventory varchar(2048) not null,
  backpack varchar(2048) not null,
  model varchar(100) default null,
  
  primary key pk_cust_loadout (id)
) character set utf8 engine=InnoDB;
