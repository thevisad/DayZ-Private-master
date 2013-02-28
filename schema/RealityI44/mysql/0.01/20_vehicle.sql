delete from instance_vehicle where instance_id = (SELECT instance.id FROM world INNER JOIN instance ON world.id = instance.world_id WHERE world.`name` = 'i44.chernarus');
delete from world_vehicle where world_id = 17;
delete from vehicle where id > 101 and id < 113;
INSERT INTO `vehicle` (`id`, `class_name`, `damage_min`, `damage_max`, `fuel_min`, `fuel_max`, `limit_min`, `limit_max`, `parts`, `inventory`) VALUES
(102, 'I44_Car_A_WillysMB_Army', '0.400', '0.800', '0.000', '0.000', 0, 5, 'engine,windshield_L,body,Wheel_LF,Wheel_RF,Wheel_LB,Wheel_RB', '[]'),
(103, 'I44_Truck_A_GMC_CCKW_Army', '0.400', '0.800', '0.000', '0.000', 0, 2, 'engine,windshield_L,windshield_R,body,fuel,Wheel_LF,Wheel_RF,Wheel_LB2,Wheel_RB2,Wheel_LB,Wheel_RB', '[]'),
(104, 'I44_Truck_A_GMC_CCKW_Open_Army', '0.400', '0.800', '0.200', '0.800', 0, 2, 'engine,windshield_L,windshield_R,body,fuel,Wheel_LF,Wheel_RF,Wheel_LB2,Wheel_RB2,Wheel_LB,Wheel_RB', '[]'),
(105, 'I44_Boat_A_InflatableBoat_Army', '0.000', '0.000', '0.000', '0.000', 0, 3, NULL, '[]'),
(106, 'I44_Boat_A_M1_AssaultBoat_Army', '0.000', '0.000', '0.000', '0.000', 0, 2, NULL, '[]'),
(107, 'I44_P47', '0.000', '0.000', '0.000', '0.000', 0, 1, NULL, '[]'),
(108, 'I44_Plane_B_SpitfireMk1a_RAF', '0.000', '1.000', '0.000', '0.000', 0, 1, NULL, '[]'),
(109, 'I44_motorcycle_G_BMWR75_SS', '0.400', '0.700', '0.000', '0.000', 0, 7, 'engine,body', '[]'),
(110, 'I44_Car_G_Kfz1_Camo_SS', '0.400', '0.700', '0.001', '0.002', 0, 2, 'engine,windshield_L,body,Wheel_LF,Wheel_RF,Wheel_LB,Wheel_RB', '[]'),
(111, 'I44_Car_G_Kfz1_CamoOpen_SS', '0.400', '0.700', '0.001', '0.002', 0, 2, 'engine,windshield_L,body,Wheel_LF,Wheel_RF,Wheel_LB,Wheel_RB', '[]'),
(112, 'I44_Car_G_Kfz1_Gray_SS', '0.400', '0.700', '0.001', '0.002', 0, 2, 'engine,windshield_L,body,Wheel_LF,Wheel_RF,Wheel_LB,Wheel_RB', '[]');