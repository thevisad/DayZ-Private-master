create table if not exists cust_loadout_profile (
  cust_loadout_id bigint unsigned not null,
  unique_id varchar(128) not null,

  primary key pk_cust_loadout_profile (cust_loadout_id, unique_id),
  foreign key fk1_cust_loadout_profile (cust_loadout_id) references cust_loadout (id),
  foreign key fk2_cust_loadout_profile (unique_id) references profile (unique_id)
) character set utf8 engine=InnoDB;
