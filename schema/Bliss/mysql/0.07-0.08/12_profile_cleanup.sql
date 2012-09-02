update
  main m
  inner join profile p on (m.uid = p.unique_id)
set
  m.unique_id = p.id;

alter table main 
  drop column uid,
  drop column name,
  drop column humanity;
