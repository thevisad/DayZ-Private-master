drop procedure if exists `proc_checkWhitelist`;
alter table instances drop column whitelist;
alter table profile drop column is_whitelisted;

