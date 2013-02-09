-- Scheduler table holds scheduler messages
create table if not exists scheduler (
	id		int(11) not null auto_increment,
	message		varchar(1024) not null,
	mtype		varchar(1) not null default 'm',
	looptime	int(3) unsigned not null default 0,
	mstart		int(3) unsigned not null default 10,
	visibility	int(1) unsigned not null default 0,

	constraint pk_scheduler primary key (id)
) character set utf8 engine=InnoDB;
