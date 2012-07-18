CREATE  TABLE `dayz`.`scheduler`
(
  `id` INT NOT NULL AUTO_INCREMENT ,
  `message` VARCHAR(1024) NOT NULL COMMENT 'Text of the message' ,
  `mtype` VARCHAR(1) NOT NULL DEFAULT 'm' COMMENT 'Type of the message: g Global, m Side, l Logic, s Script' ,
  `looptime` INT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'The time delay before the message is executed again. 0 means message will be executed only once' ,
  `mstart` INT(3) UNSIGNED NOT NULL DEFAULT 10 COMMENT 'The time before the message is processed in seconds' ,
  PRIMARY KEY (`id`) 
);

CREATE  TABLE `dayz`.`whitelist` 
(
  `id` INT NOT NULL AUTO_INCREMENT ,
  `uid` VARCHAR(128) NOT NULL ,
  PRIMARY KEY (`id`) 
)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COMMENT = 'Allowed UIDs';

ALTER TABLE `dayz`.`messages` CHANGE COLUMN `visibility` `visibility` INT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Set on which instance message will be executed'  ;
ALTER TABLE `dayz`.`instances` ADD COLUMN `mvisibility` INT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sets which messages will be executed by the scheduler'  AFTER `loadout` , CHANGE COLUMN `instance` `instance` INT(2) UNSIGNED NOT NULL COMMENT 'Identification number for instance'  , CHANGE COLUMN `timezone` `timezone` INT(1) NOT NULL DEFAULT '0' COMMENT 'Set the timezone for the instance relative to the DB time'  , CHANGE COLUMN `loadout` `loadout` VARCHAR(1024) NOT NULL DEFAULT '[]' COMMENT 'Starting inventory for every player. Has to be a valid inventory string to work'  ;
ALTER TABLE `dayz`.`main` CHANGE COLUMN `uid` `uid` VARCHAR(128) NOT NULL COMMENT 'Player ID generated from CDKEY used for identification'  , CHANGE COLUMN `name` `name` VARCHAR(32) NOT NULL DEFAULT 'GI Joe' COMMENT 'Name of the player'  , CHANGE COLUMN `pos` `pos` VARCHAR(255) NOT NULL DEFAULT '[]' COMMENT 'Position of the player. [] means random at the beach'  , CHANGE COLUMN `inventory` `inventory` VARCHAR(1024) NOT NULL DEFAULT '[]' COMMENT 'Inventory string of the player.'  , CHANGE COLUMN `backpack` `backpack` VARCHAR(1024) NOT NULL DEFAULT '["DZ_Patrol_Pack_EP1"|[[]|[]]|[[]|[]]]' COMMENT 'Backpack of the player. [] means deafult starting backpack'  , CHANGE COLUMN `medical` `medical` VARCHAR(255) NOT NULL DEFAULT '[false|false|false|false|false|false|false|12000|[]|[0|0]|0]' COMMENT 'Medical values of the player. [] means defaults'  , CHANGE COLUMN `death` `death` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Is player dead? 0 for alive, 1 for dead'  , CHANGE COLUMN `model` `model` VARCHAR(128) NOT NULL DEFAULT 'Survivor2_DZ' COMMENT 'Model of the player'  , CHANGE COLUMN `state` `state` VARCHAR(128) NOT NULL DEFAULT '[""|"aidlpercmstpsnonwnondnon_player_idlesteady04"|36]' COMMENT 'Last state the player was in'  , CHANGE COLUMN `hkills` `hkills` INT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Human kills'  , CHANGE COLUMN `bkills` `bkills` INT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Bandit kills'  , CHANGE COLUMN `kills` `kills` INT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Zombie kills'  , CHANGE COLUMN `hs` `hs` INT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Zombie headshots'  , CHANGE COLUMN `late` `late` INT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Last time player ate in mins'  , CHANGE COLUMN `ldrank` `ldrank` INT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Last time player drank in mins'  , CHANGE COLUMN `stime` `stime` INT(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Playtime in minutes'  , CHANGE COLUMN `lastupdate` `lastupdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update to the player data'  , CHANGE COLUMN `survival` `survival` DATETIME NOT NULL COMMENT 'Creation date of the account used to calculate survival time'  ;
ALTER TABLE `dayz`.`objects` CHANGE COLUMN `uid` `uid` VARCHAR(50) NOT NULL DEFAULT '0' COMMENT 'Object game generated ID'  , CHANGE COLUMN `pos` `pos` VARCHAR(255) NOT NULL DEFAULT '[]' COMMENT 'Postition of the object'  , CHANGE COLUMN `inventory` `inventory` VARCHAR(1024) NOT NULL DEFAULT '[]' COMMENT 'Loot stored in the object'  , CHANGE COLUMN `health` `health` VARCHAR(1024) NOT NULL DEFAULT '[]' COMMENT 'Broken parts of the object'  , CHANGE COLUMN `fuel` `fuel` DOUBLE NOT NULL DEFAULT '0' COMMENT 'Ammount of fuel. 0-1'  , CHANGE COLUMN `damage` `damage` DOUBLE NOT NULL DEFAULT '0' COMMENT 'Overall damage value. 0-1'  , CHANGE COLUMN `otype` `otype` VARCHAR(255) NOT NULL DEFAULT 'none' COMMENT 'Type of the object'  , CHANGE COLUMN `oid` `oid` INT(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Owner of the object. Only relevant for tents'  , CHANGE COLUMN `instance` `instance` INT(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Instance number in which object resides'  , CHANGE COLUMN `lastupdate` `lastupdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update to the object'  ;
ALTER TABLE `dayz`.`spawns` CHANGE COLUMN `pos` `pos` VARCHAR(128) NOT NULL COMMENT 'Spawn location'  , CHANGE COLUMN `otype` `otype` VARCHAR(128) NOT NULL DEFAULT 'Smallboat_1' COMMENT 'Type of the spawning object'  ;
ALTER TABLE `dayz`.`instances` ADD COLUMN `reserverd` INT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Not yet implemented' AFTER `mvisibility` ;
USE `dayz`;
DROP procedure IF EXISTS `updIH`;
DELIMITER $$
USE `dayz`$$
CREATE DEFINER=`dayz`@`localhost` PROCEDURE `updIH`(IN myid INT,IN myhealth VARCHAR(1024),IN myhp DOUBLE)
BEGIN
      UPDATE objects SET health=myhealth,damage=myhp WHERE id=myid;
END
$$
DELIMITER ;

USE `dayz`;
DROP procedure IF EXISTS `updII`;
DELIMITER $$
USE `dayz`$$
CREATE DEFINER=`dayz`@`localhost` PROCEDURE `updII`(IN myid INT,IN myinv VARCHAR(1024))
BEGIN
      UPDATE objects SET inventory=myinv WHERE id=myid;
END
$$
DELIMITER ;
USE `dayz`;

DROP procedure IF EXISTS `updUI`;



DELIMITER $$

USE `dayz`$$

CREATE DEFINER=`dayz`@`localhost` PROCEDURE `updUI`(IN myuid VARCHAR(50),IN myinv VARCHAR(1024))

BEGIN

      UPDATE objects SET inventory=myinv WHERE uid=myuid;

END

$$



DELIMITER ;
USE `dayz`;

DROP procedure IF EXISTS `updV`;



DELIMITER $$

USE `dayz`$$

CREATE DEFINER=`dayz`@`localhost` PROCEDURE `updV`(IN myuid VARCHAR(50),IN mytype VARCHAR(255) ,IN mypos VARCHAR(255), IN myhealth VARCHAR(1024))

BEGIN

      UPDATE objects SET otype=if(mytype='',otype,mytype),health=myhealth,pos=if(mypos='[]', pos,mypos) WHERE uid=myuid;

END

$$



DELIMITER ;




