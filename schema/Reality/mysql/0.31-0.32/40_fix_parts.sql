update instance_vehicle iv join world_vehicle wv on iv.world_vehicle_id = wv.id join vehicle v on wv.vehicle_id = v.id set iv.parts = '[]' where v.parts in ('[["motor",0.8]]', '[["motor",0.8],["karoserie",1],["palivo",0.8],["wheel_1_1_steering",1],["wheel_2_1_steering",1],["wheel_1_2_steering",1],["wheel_2_2_steering",1],["sklo predni P",1],["sklo predni L",1],["glass1",1],["glass2",1],["glass3",1]]');

update vehicle set parts = 'motor' where parts = '[["motor",0.8]]';
update vehicle set parts = 'motor,karoserie,palivo,wheel_1_1_steering,wheel_2_1_steering,wheel_1_2_steering,wheel_2_2_steering,sklo predni P,sklo predni L,glass1,glass2,glass3' where parts = '[["motor",0.8],["karoserie",1],["palivo",0.8],["wheel_1_1_steering",1],["wheel_2_1_steering",1],["wheel_1_2_steering",1],["wheel_2_2_steering",1],["sklo predni P",1],["sklo predni L",1],["glass1",1],["glass2",1],["glass3",1]]';

