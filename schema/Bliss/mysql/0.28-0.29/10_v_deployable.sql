create or replace view v_deployable as
  select
    id.id instance_deployable_id,
    d.id  vehicle_id,
    d.class_name,
    s.id owner_id,
    p.name owner_name,
    p.unique_id owner_unique_id,
    s.is_dead is_owner_dead,
    id.worldspace,
    id.inventory
  from
    instance_deployable id
    join deployable d on id.deployable_id = d.id
    join survivor s on id.owner_id = s.id
    join profile p on s.unique_id = p.unique_id;
