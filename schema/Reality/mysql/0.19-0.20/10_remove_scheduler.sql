drop procedure if exists `proc_getSchedulerTaskPageCount`;
drop procedure if exists `proc_getSchedulerTasks`;

drop table scheduler;
alter table instances drop column mvisibility;

