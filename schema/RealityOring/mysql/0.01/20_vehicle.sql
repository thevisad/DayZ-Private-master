delete from world_vehicle where vehicle_id > 94 and vehicle_id < 102;
delete from world_vehicle where world_id = 16;
delete from instance_vehicle where world_vehicle_id > 94 and world_vehicle_id < 102;
delete from vehicle where id > 94 and id < 102;
ALTER TABLE `vehicle`
AUTO_INCREMENT=94;
INSERT INTO `vehicle` (`id`, `class_name`, `damage_min`, `damage_max`, `fuel_min`, `fuel_max`, `limit_min`, `limit_max`, `parts`, `inventory`) VALUES (95, 'Buggy_DZ', 0.000, 0.050, 0.100, 0.800, 0, 2, NULL, '[]');
INSERT INTO `vehicle` (`id`, `class_name`, `damage_min`, `damage_max`, `fuel_min`, `fuel_max`, `limit_min`, `limit_max`, `parts`, `inventory`) VALUES (96, 'CH47_DZ', 0.000, 0.500, 0.100, 0.800, 0, 1, NULL, '[]');
INSERT INTO `vehicle` (`id`, `class_name`, `damage_min`, `damage_max`, `fuel_min`, `fuel_max`, `limit_min`, `limit_max`, `parts`, `inventory`) VALUES (97, 'CSJ_GyroP', 0.000, 0.050, 0.100, 0.800, 0, 2, NULL, '[]');
INSERT INTO `vehicle` (`id`, `class_name`, `damage_min`, `damage_max`, `fuel_min`, `fuel_max`, `limit_min`, `limit_max`, `parts`, `inventory`) VALUES (98, 'HMMWV_Ambulance_DZ', 0.000, 0.500, 0.100, 0.800, 0, 1, NULL, '[]');
INSERT INTO `vehicle` (`id`, `class_name`, `damage_min`, `damage_max`, `fuel_min`, `fuel_max`, `limit_min`, `limit_max`, `parts`, `inventory`) VALUES (99, 'Oring_Ikarus', 0.000, 0.500, 0.100, 0.800, 0, 3, NULL, '[]');
INSERT INTO `vehicle` (`id`, `class_name`, `damage_min`, `damage_max`, `fuel_min`, `fuel_max`, `limit_min`, `limit_max`, `parts`, `inventory`) VALUES (100, 'Policecar', 0.000, 0.500, 0.100, 0.800, 0, 2, NULL, '[]');
INSERT INTO `vehicle` (`id`, `class_name`, `damage_min`, `damage_max`, `fuel_min`, `fuel_max`, `limit_min`, `limit_max`, `parts`, `inventory`) VALUES (101, 'SUV_TK_EP1', 0.000, 0.500, 0.100, 0.800, 0, 2, NULL, '[]');
