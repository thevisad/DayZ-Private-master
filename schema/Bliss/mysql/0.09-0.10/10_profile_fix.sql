alter table profile
  modify survival_attempts int(3) unsigned not null default 1,
  modify total_survival_time int(5) unsigned not null default 0,
  modify total_survivor_kills int(4) unsigned not null default 0,
  modify total_bandit_kills int(4) unsigned not null default 0,
  modify total_zombie_kills int(5) unsigned not null default 0,
  modify total_headshots int(5) unsigned not null default 0;
