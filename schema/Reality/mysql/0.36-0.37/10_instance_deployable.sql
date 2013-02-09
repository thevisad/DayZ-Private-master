ALTER TABLE `instance_deployable`
ADD COLUMN `Hitpoints`  varchar(500) NOT NULL DEFAULT '[]' AFTER `created`,
ADD COLUMN `Fuel`  double(13,0) NOT NULL DEFAULT 0 AFTER `Hitpoints`,
ADD COLUMN `Damage`  double(13,0) NOT NULL DEFAULT 0 AFTER `Fuel`;