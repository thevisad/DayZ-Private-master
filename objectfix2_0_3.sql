USE `dayz`;

DROP procedure IF EXISTS `getO`;



DELIMITER $$

USE `dayz`$$

CREATE DEFINER=`dayz`@`localhost` PROCEDURE `getO`(IN myinstance INT,IN page INT)

BEGIN

      SELECT id,otype,oid,pos,inventory,health,fuel,damage FROM objects WHERE instance=myinstance LIMIT page,1;

END

$$



DELIMITER ;