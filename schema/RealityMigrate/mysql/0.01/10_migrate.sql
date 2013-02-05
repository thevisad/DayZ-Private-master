update migration_schema_version set name = replace(name, 'Bliss', 'Reality');
update migration_schema_log set schema_name = replace(schema_name, 'Bliss', 'Reality');