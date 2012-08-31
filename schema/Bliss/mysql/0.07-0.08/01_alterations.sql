ALTER TABLE `objects` ADD INDEX `instance` (`instance`);

ALTER TABLE `main`
	RENAME TO `character`,
	CHANGE COLUMN `pos` `position` VARCHAR(255) NOT NULL DEFAULT '[]' AFTER `player_id`,
	CHANGE COLUMN `death` `is_dead` INT(1) UNSIGNED NOT NULL DEFAULT '0' AFTER `medical`,
	CHANGE COLUMN `humanity` `humanity` INT(5) NOT NULL DEFAULT '2500' AFTER `state`,
	CHANGE COLUMN `hkills` `survivor_kills` INT(3) UNSIGNED NOT NULL DEFAULT '0' AFTER `humanity`,
	CHANGE COLUMN `bkills` `bandit_kills` INT(3) UNSIGNED NOT NULL DEFAULT '0' AFTER `survivor_kills`,
	CHANGE COLUMN `kills` `zombie_kills` INT(4) UNSIGNED NOT NULL DEFAULT '0' AFTER `bandit_kills`,
	CHANGE COLUMN `hs` `headshots` INT(4) UNSIGNED NOT NULL DEFAULT '0' AFTER `zombie_kills`,
	CHANGE COLUMN `late` `last_ate` INT(3) UNSIGNED NOT NULL DEFAULT '0' AFTER `headshots`,
	CHANGE COLUMN `ldrank` `last_drank` INT(3) UNSIGNED NOT NULL DEFAULT '0' AFTER `last_ate`,
	CHANGE COLUMN `stime` `survival_time` INT(3) UNSIGNED NOT NULL DEFAULT '0' AFTER `last_drank`,
	CHANGE COLUMN `survival` `start_time` DATETIME NOT NULL AFTER `lastupdate`,
	CHANGE COLUMN `lastupdate` `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `survival_time`,
	ADD INDEX `is_dead` (`is_dead`); --


ALTER TABLE `character`
	ADD COLUMN `player_id` INT(8) NOT NULL AFTER `id`,
	ADD INDEX `player_id` (`player_id`); --
	
CREATE TABLE `profile` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`unique_id` INT UNSIGNED NOT NULL,
	`name` VARCHAR(64) NOT NULL DEFAULT 'NONAME',
	`survival_attempts` INT(3) UNSIGNED NOT NULL,
	`total_survival_time` INT(5) UNSIGNED NOT NULL,
	`total_survivor_kills` INT(4) UNSIGNED NOT NULL,
	`total_bandit_kills` INT(4) UNSIGNED NOT NULL,
	`total_zombie_kills` INT(5) UNSIGNED NOT NULL,
	`total_headshots` INT(5) UNSIGNED NOT NULL,
	`total_humanity` INT(6) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `unique_id` (`unique_id`);
)
COMMENT='Stores persistent data for players, across all survival attempts.'
COLLATE='utf8_general_ci'
ENGINE=InnoDB; --

SET @id=0;
INSERT IGNORE INTO profile 
	SELECT
		@id:=@id+1 AS id, 
		uid as unique_id, 
		name, 
		COUNT(*) as survival_attempts, 
		SUM(survival_time) AS total_survival_time, 
		SUM(survivor_kills) as total_survivor_kills, 
		SUM(bandit_kills) as total_bandit_kills, 
		SUM(zombie_kills) as total_zombie_kills, 	
		SUM(headshots) as total_headshots, 	
		SUM(humanity) as total_humanity 	
	FROM character 
	GROUP BY uid 
	ORDER BY start_time DESC; --
	
UPDATE character SET player_id = (SELECT id FROM profile WHERE character.uid=profile.unique_id);

ALTER TABLE `character`
	DROP COLUMN `uid`,
	DROP COLUMN `name`;