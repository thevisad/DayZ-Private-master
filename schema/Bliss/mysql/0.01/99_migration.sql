-- Store versions we have been upgraded to
create table if not exists migration_schema_version (
	name	varchar(255) not null,
	version varchar(255) not null,

	constraint pk_migration_schema_version primary key (name)
) character set utf8 engine=InnoDB;

-- Store a log of upgrade attempts
create table if not exists migration_schema_log (
	id		int(11) unsigned not null auto_increment,
	schema_name	varchar(255) not null,
	event_time	timestamp not null default CURRENT_TIMESTAMP,
	old_version	varchar(255) not null,
	new_version	varchar(255) not null,

	constraint pk_migration_schema_log primary key (id)
) character set utf8 engine=InnoDB;
