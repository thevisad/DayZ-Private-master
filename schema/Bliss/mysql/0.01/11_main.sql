-- Main table holds character data
create table if not exists main (
	id		int(8) unsigned not null auto_increment,
	uid		varchar(128) not null,
	name		varchar(32) not null default 'Unnamed',
	pos		varchar(255) not null default '[]',
	inventory	varchar(1024) not null default '[]',
	backpack	varchar(1024) not null default '["DZ_Patrol_Pack_EP1"|[[]|[]]|[[]|[]]]',
	medical		varchar(255) not null default '[false|false|false|false|false|false|false|12000|[]|[0|0]|0]',
	death		int(1) unsigned not null default 0,
	model		varchar(128) not null default 'Survivor2_DZ',
	state		varchar(128) not null default '[""|"aidlpercmstpsnonwnondnon_player_idlesteady04"|36]',
	humanity	int(2) not null default 2500,
	hkills		int(2) unsigned not null default 0,
	bkills		int(2) unsigned not null default 0,
	kills		int(2) unsigned not null default 0,
	hs		int(2) unsigned not null default 0,
	late		int(2) unsigned not null default 0,
	ldrank		int(2) unsigned not null default 0,
	stime		int(2) unsigned not null default 0,
	lastupdate	timestamp not null default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	survival	datetime not null,

	constraint pk_main primary key (id)
) character set utf8 engine=InnoDB;
