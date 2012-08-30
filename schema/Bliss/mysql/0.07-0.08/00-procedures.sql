DROP PROCEDURE IF EXISTS `delO`;
CREATE PROCEDURE `proc_deleteObject`(IN `param_UniqueId` VARCHAR(50))
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
      DELETE FROM objects WHERE uid=param_UniqueId;
END;


DROP PROCEDURE IF EXISTS `getLoadout`;
CREATE PROCEDURE `proc_getInstanceLoadout`(IN `param_InstanceId` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
   SELECT loadout FROM instances WHERE instance = param_InstanceId;
END;


DROP PROCEDURE IF EXISTS `getO`;
CREATE PROCEDURE `proc_getObjects`(IN `param_InstanceId` int, IN `param_CurrentPage` int)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	DECLARE itemsPerPage INT DEFAULT 5; -- Must match proc_getObjectPageCount
	DECLARE currentOffset INT DEFAULT (itemsPerPage * param_CurrentPage);
	SELECT id, otype, oid, pos, inventory, health, fuel, damage FROM objects WHERE instance = param_InstanceId LIMIT currentOffset, itemsPerPage;
END;


DROP PROCEDURE IF EXISTS `getOC`;
CREATE PROCEDURE `proc_getObjectPageCount`(IN `param_InstanceId` int)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	DECLARE itemsPerPage INT DEFAULT 5; -- Must match proc_getObjects
	SELECT FLOOR(COUNT(*) / itemsPerPage) from objects WHERE instance = param_InstanceId;
END;


DROP PROCEDURE IF EXISTS `getTasks`;
CREATE PROCEDURE `proc_getSchedulerTasks`(IN `param_InstanceId` int, IN `param_CurrentPage` int)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	DECLARE itemsPerPage INT DEFAULT 10; -- Must match proc_getSchedulerTaskPageCount
	DECLARE currentOffset INT DEFAULT (itemsPerPage * param_CurrentPage);
	SELECT message, mtype, looptime, mstart FROM scheduler JOIN instances ON instances.mvisibility = scheduler.visibility WHERE instances.instance = param_InstanceId LIMIT currentOffset, itemsPerPage;
END;


DROP PROCEDURE IF EXISTS `getTC`;
CREATE PROCEDURE `proc_getSchedulerTaskPageCount`(IN `param_InstanceId` int)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	DECLARE itemsPerPage INT DEFAULT 10; -- Must match proc_getSchedulerTasks
	SELECT FLOOR(COUNT(*) / itemsPerPage) FROM scheduler JOIN instances ON instances.mvisibility = scheduler.visibility WHERE instances.instance = param_InstanceId;
END;

DROP PROCEDURE IF EXISTS `getTime`;
CREATE PROCEDURE `proc_getInstanceTime`(IN `param_InstanceID` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT 'Gets the current game time for an instance, respecting the timezone offset as per defined in the instances table.'
BEGIN
	DECLARE server_time DATETIME DEFAULT NOW(); -- Declare a variable to hold the localised server time, the default is NOW() in case the instance param is invalid in the query below.
	SELECT NOW() + INTERVAL (timezone) HOUR INTO server_time FROM instances WHERE instance = param_InstanceID; -- Select the current server DATETIME and modify it by the timezone offset, before stuffing it into the variable, skipped if timezone == null
	SELECT DATE_FORMAT(server_time,'%d-%m-%Y'), TIME_FORMAT(server_time, '%T'); -- Return the results.
END;


DROP PROCEDURE IF EXISTS `insOselI`;
CREATE PROCEDURE `proc_insertObject`(IN `param_ObjectUniqueId` VARCHAR(50), IN `param_ObjectType` VARCHAR(255), IN `param_ObjectHealth` VARCHAR(1024), IN `param_ObjectDamage` DOUBLE, IN `param_ObjectFuel` DOUBLE, IN `param_ObjectOwner` INT, IN `param_ObjectPosition` VARCHAR(255), IN `param_InstanceId` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT 'Inserts a new object into the Database'
BEGIN
	INSERT IGNORE INTO objects (uid,otype,health,damage,oid,pos,fuel,instance) VALUES (param_ObjectUniqueId, param_ObjectType, param_ObjectHealth, param_ObjectDamage, param_ObjectOwner, param_ObjectPosition, param_ObjectFuel, param_InstanceId);
END;

DROP PROCEDURE IF EXISTS `insUNselI`;
CREATE PROCEDURE `proc_insertPlayer`(IN `param_PlayerUniqueId` varchar(128), IN `param_PlayerName` varchar(255))
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	INSERT INTO main (uid, name, survival) VALUES (param_PlayerUniqueId, param_PlayerName, NOW());
	SELECT LAST_INSERT_ID();
END;

DROP PROCEDURE IF EXISTS `logLogin`;
CREATE PROCEDURE `proc_logLogin`(IN `param_PlayerUniqueId` varchar(50))
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	INSERT IGNORE INTO log_entry (profile_id, log_code_id) VALUES (param_PlayerUniqueId, 1);
END;


DROP PROCEDURE IF EXISTS `logLogout`;
CREATE PROCEDURE `proc_logLogout`(IN `param_PlayerUniqueId` varchar(50))
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	INSERT IGNORE INTO log_entry (profile_id, log_code_id) VALUES (param_PlayerUniqueId, 2);
END;


DROP PROCEDURE IF EXISTS `selIIBSM`;
CREATE PROCEDURE `proc_getPlayer`(IN `param_PlayerUniqueId` varchar(128), IN `param_PlayerName` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT 'Select ID, Inventory, Backpack, Survival Time and Model.'
BEGIN 
	UPDATE main SET name = param_PlayerName WHERE uid = param_PlayerUniqueId;
	SELECT id, inventory, backpack, FLOOR(TIME_TO_SEC(TIMEDIFF(NOW(), survival))/60), model, late, ldrank FROM main WHERE uid = param_PlayerUniqueId AND death = 0;
END;


DROP PROCEDURE IF EXISTS `selMPSSH`;
CREATE PROCEDURE `proc_getPlayerStats`(IN `param_PlayerID` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
      SELECT medical, pos, kills, state, humanity, hs, hkills, bkills FROM main WHERE id = param_PlayerID AND death=0;
END;


DROP PROCEDURE IF EXISTS `setCD`;
CREATE PROCEDURE `proc_setPlayerDead`(IN `param_PlayerId` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
      UPDATE main SET death=1 WHERE id = param_PlayerId;
END;

DROP PROCEDURE IF EXISTS `update`;
CREATE PROCEDURE `proc_updatePlayer`(IN `param_PlayerId` int, IN `param_PlayerPositon` varchar(1024), IN `param_PlayerInventory` varchar(2048), IN `param_PlayerBackpack` varchar(2048), IN `param_PlayerMedicalStatus` varchar(1024), IN `param_PlayerLastAte` int, IN `param_PlayerLastDrank` int, IN `param_PlayerSurvivalTime` int, IN `param_PlayerModel` varchar(255), IN `param_PlayerHumanity` int, IN `param_PlayerZombieKills` int, IN `param_PlayerHeadshots` int, IN `param_PlayerMurders` int, IN `param_PlayerBanditKills` int, IN `param_PlayerState` varchar(255))
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	UPDATE main SET
		kills=kills+param_PlayerZombieKills,
		hs=hs+param_PlayerHeadshots,
		bkills=bkills+param_PlayerBanditKills,
		hkills=hkills+param_PlayerMurders,
		state=param_PlayerState,
		model=IF(param_PlayerModel='any',model,param_PlayerModel),
		late=IF(param_PlayerLastAte=-1,0,late+param_PlayerLastAte),
		ldrank=IF(param_PlayerLastDrank<-1,0,ldrank+param_PlayerLastDrank),
		stime=stime+param_PlayerSurvivalTime,
		pos=IF(param_PlayerPositon='[]', pos, param_PlayerPositon),
		humanity=IF(param_PlayerHumanity=0, humanity, param_PlayerHumanity),
		medical=IF(param_PlayerMedicalStatus='[]', medical, param_PlayerMedicalStatus),
		backpack=IF(param_PlayerBackpack='[]', backpack, param_PlayerBackpack),
		inventory=IF(param_PlayerInventory='[]', inventory, param_PlayerInventory)
	WHERE id = param_PlayerId;
END;

DROP PROCEDURE IF EXISTS `updIH`;
CREATE PROCEDURE `proc_updateObjectHealth`(IN `param_ObjectId` INT, IN `param_ObjectHealth` VARCHAR(1024), IN `param_ObjectDamage` DOUBLE)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	UPDATE objects SET health=param_ObjectHealth,damage=param_ObjectDamage WHERE id=param_ObjectId;
END;


DROP PROCEDURE IF EXISTS `updII`;
CREATE PROCEDURE `proc_updateObjectInventory`(IN `param_ObjectId` int, IN `param_ObjectInventory` varchar(1024))
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	UPDATE objects SET inventory=param_ObjectInventory WHERE id = param_ObjectId; 
END;


DROP PROCEDURE IF EXISTS `updIPF`;
CREATE PROCEDURE `proc_updateObjectPosition`(IN `param_ObjectId` INT, IN `param_ObjectPosition` VARCHAR(255), IN `param_ObjectFuel` DOUBLE)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	UPDATE objects SET pos=if(param_ObjectPosition='[]', pos, param_ObjectPosition),fuel=param_ObjectFuel WHERE id = param_ObjectId;
END;


DROP PROCEDURE IF EXISTS `updUI`;
CREATE PROCEDURE `proc_updateObjectInventoryByUID`(IN `param_ObjectUniqueId` varchar(50), IN `param_ObjectInventory` varchar(8192))
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	UPDATE objects SET inventory = param_ObjectInventory WHERE uid NOT LIKE '%.%' AND (CONVERT(uid, UNSIGNED INTEGER) BETWEEN (CONVERT(param_ObjectUniqueId, UNSIGNED INTEGER) - 2) AND (CONVERT(param_ObjectUniqueId, UNSIGNED INTEGER) + 2));
END;


DROP PROCEDURE IF EXISTS `updV`;
CREATE PROCEDURE `proc_updateObject`(IN `param_ObjectUniqueId` VARCHAR(50), IN `param_ObjectType` VARCHAR(255) , IN `param_ObjectPosition` VARCHAR(255), IN `param_ObjectHealth` VARCHAR(1024))
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	UPDATE objects SET otype=if(param_ObjectType='',otype,param_ObjectType),health=param_ObjectHealth,pos=if(param_ObjectPosition='[]',pos,param_ObjectPosition) WHERE uid=param_ObjectUniqueId;
END;


DROP PROCEDURE `selIPIBMSSS`;
