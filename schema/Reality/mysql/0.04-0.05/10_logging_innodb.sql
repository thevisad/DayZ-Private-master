alter table log_code engine=InnoDB;
alter table log_entry engine=InnoDB;

alter table log_entry add constraint fk1_log_entry foreign key (log_code_id) references log_code (id);
