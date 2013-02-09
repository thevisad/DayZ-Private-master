-- Stores whitelisted UIDs
create table if not exists whitelist (
	id		int(11) not null auto_increment,
	uid		varchar(128) not null,

	constraint pk_whitelist primary key (id)
) character set utf8 engine=InnoDB;
