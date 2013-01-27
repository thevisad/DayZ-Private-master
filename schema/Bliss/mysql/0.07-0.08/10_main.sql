alter table main
  change uid unique_id varchar(128) not null after id,
  change death is_dead int(1) unsigned not null default '0' after medical,
  change humanity humanity int(5) not null default '2500' after state,
  change hkills survivor_kills int(3) unsigned not null default '0' after humanity,
  change bkills bandit_kills int(3) unsigned not null default '0' after survivor_kills,
  change kills zombie_kills int(4) unsigned not null default '0' after bandit_kills,
  change hs headshots int(4) unsigned not null default '0' after zombie_kills,
  change late last_ate int(3) unsigned not null default '0' after headshots,
  change ldrank last_drank int(3) unsigned not null default '0' after last_ate,
  change stime survival_time int(3) unsigned not null default '0' after last_drank,
  change lastupdate last_update timestamp not null default current_timestamp on update current_timestamp after survival_time,
  change survival start_time datetime not null after last_update;
