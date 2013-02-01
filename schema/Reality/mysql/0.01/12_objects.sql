-- Objects table holds vehicles/objects to spawn
create table if not exists objects (
	id		int(11) unsigned not null auto_increment,
	uid		varchar(50) not null default 0,
	pos		varchar(255) not null default '[]',
	inventory	varchar(1024) not null default '[]',
	health		varchar(1024) not null default '[]',
	fuel		double not null default 0,
	damage		double not null default 0,
	otype		varchar(255) not null default 'none',
	oid		int(11) unsigned not null default 0,
	instance	int(11) unsigned not null default 0,
	lastupdate	timestamp not null default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,

	constraint pk_objects primary key (id)
) character set utf8 engine=InnoDB;
