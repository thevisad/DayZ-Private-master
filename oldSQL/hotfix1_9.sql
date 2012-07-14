ALTER TABLE `dayz`.`main` CHANGE COLUMN `pos` `pos` VARCHAR(255) NOT NULL DEFAULT '[]'  , CHANGE COLUMN `medical` `medical` VARCHAR(255) NOT NULL DEFAULT '[false|false|false|false|false|false|false|12000|[]|[0|0]|0]'  ;
USE `dayz`;

DROP procedure IF EXISTS `getO`;



DELIMITER $$

USE `dayz`$$

CREATE DEFINER=`dayz`@`localhost` PROCEDURE `getO`(IN myinstance INT,IN page INT)

BEGIN

    SET @i = myinstance;

    SET @p = page;

    PREPARE stmt1 FROM 'SELECT id,otype,oid,pos,inventory,health,fuel,damage FROM objects WHERE instance=? LIMIT ?,10';

    EXECUTE stmt1 USING @i,@p;

    DEALLOCATE PREPARE stmt1;

END

$$



DELIMITER ;
ALTER TABLE `dayz`.`instances` CHANGE COLUMN `timezone` `timezone` INT(1) NOT NULL DEFAULT '0'  ;