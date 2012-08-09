alter table objects modify inventory varchar(2048) not null default '[]';
alter table main modify inventory varchar(2048) not null default '[]';
alter table main modify backpack varchar(2048) not null default '[]';

create table if not exists log_code (
	id int(11) unsigned not null auto_increment,
	name varchar(50) not null,
	description varchar(255) null default '',

	constraint pk_log_code primary key (id),
	constraint uq_log_code unique key (name)
) character set utf8 engine=InnoDB;

create table if not exists log_entry (
	id int(11) unsigned not null auto_increment,
	profile_id int(11) unsigned not null,
	log_code_id int(11) unsigned not null,
	text varchar(1024) null default '',
	created timestamp not null default current_timestamp,

	constraint pk_log_entry primary key (id)
) character set utf8 engine=InnoDB;

insert ignore into log_code (id, name, description) values (1, 'Login', 'Player has logged in');
insert ignore into log_code (id, name, description) values (2, 'Logout', 'Player has logged out');
insert ignore into log_code (id, name, description) values (3, 'Ban', 'Player was banned');
insert ignore into log_code (id, name, description) values (4, 'Connect', 'Player has connected');
insert ignore into log_code (id, name, description) values (5, 'Disconnect', 'Player has disconnected');

delimiter //
drop procedure if exists `logLogin`;
create procedure `logLogin`(in unique_id varchar(50))
begin
  insert into
    log_entry (profile_id, log_code_id)
  values (unique_id, 1); --
end;
//

drop procedure if exists `logLogout`;
create procedure `logLogout`(in unique_id varchar(50))
begin
  insert into
    log_entry (profile_id, log_code_id)
  values (unique_id, 2); --
end;
//

delimiter ;
