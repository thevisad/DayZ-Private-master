alter table instance
  add column backpack varchar(2048) not null default '["DZ_Patrol_Pack_EP1",[[],[]],[[],[]]]',
  drop column tz_offset;
