create table profile (
  id int(11) unsigned not null auto_increment,
  unique_id varchar(128) not null,
  name varchar(64) not null default '',
  humanity int(6) not null default 2500,
  survival_attempts int(3) unsigned not null,
  total_survival_time int(5) unsigned not null,
  total_survivor_kills int(4) unsigned not null,
  total_bandit_kills int(4) unsigned not null,
  total_zombie_kills int(5) unsigned not null,
  total_headshots int(5) unsigned not null,
  
  primary key pk_profile (id),
  unique key uq_profile (unique_id)
) character set utf8 engine=InnoDB;

insert ignore into profile 
  select
    0 id,
    unique_id,
    name,
    humanity,
    count(*) survival_attempts,
    sum(survival_time) total_survival_time,
    sum(survivor_kills) total_survivor_kills,
    sum(bandit_kills) total_bandit_kills,
    sum(zombie_kills) total_zombie_kills,
    sum(headshots) total_headshots
  from main
  group by unique_id;
