-- Instances table holds server information
create table if not exists instances (
	id 		int(8) unsigned not null auto_increment,
	instance	int(2) unsigned not null,
	timezone	int(1) not null default 0,
	loadout		varchar(1024) not null default '[]',
	mvisibility	int(1) unsigned not null default 0,
	reserved	int(1) unsigned not null default 0,

	constraint pk_instances primary key (id),
	constraint uq_instances unique (instance)
) character set utf8 engine=InnoDB;

-- Insert default instance
insert ignore into instances (id, instance, timezone, loadout) values (1, 1, 0, '[]');
