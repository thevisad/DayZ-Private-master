INSERT INTO instance (world_id, inventory, backpack )
SELECT world.id, 
instance.inventory,
instance.backpack
FROM 
instance ,
world
WHERE world.id NOT IN (
SELECT instance.id
FROM instance);
