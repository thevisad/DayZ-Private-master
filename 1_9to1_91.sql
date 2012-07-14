ALTER TABLE `dayz`.`instances` ADD COLUMN `loadout` VARCHAR(1024) NOT NULL DEFAULT '[]'  AFTER `timezone` ;
USE `dayz`;

DROP procedure IF EXISTS `getLoadout`;



DELIMITER $$

USE `dayz`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLoadout`(IN myinstance INT)

BEGIN

    SELECT IF((SELECT loadout FROM instances WHERE instance=myinstance) IS NULL,"[]",(SELECT loadout FROM instances WHERE instance=myinstance));

END

$$



DELIMITER ;