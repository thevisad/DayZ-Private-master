create table if not exists vehicle (
  id smallint unsigned not null auto_increment,
  class_name varchar(100) default null,
  damage_min decimal(4,3) not null default '0.1',
  damage_max decimal(4,3) not null default '0.7',
  fuel_min decimal(4,3) not null default '0.2',
  fuel_max decimal(4,3) not null default '0.8',
  limit_min tinyint unsigned not null default 0,
  limit_max tinyint unsigned not null default 0,
  parts varchar(1024) default null,
  inventory varchar(2048) not null default '[]',

  primary key pk_vehicle (id),
  unique key uq1_vehicle (class_name),
  index idx1_vehicle (class_name)
) character set utf8 engine=InnoDB;

insert ignore into vehicle (class_name)
  select distinct otype from spawns;

update vehicle set parts = 'motor' where
  class_name = 'PBX'
  or class_name like '%TT650%'
  or class_name like '%boat%';

update vehicle set
  parts = 'motor,elektronika,mala vrtule,velka vrtule'
where
  class_name like '%UH1H_DZ%';

update vehicle set
  parts = 'palivo,motor,karoserie,wheel_1_1_steering,wheel_1_2_steering,wheel_2_1_steering,wheel_2_2_steering'
where
  parts is null;

update vehicle set
  parts = null, 
  limit_min = 5,
  limit_max = 5,
  damage_min = 0,
  damage_max = 0,
  fuel_min = 0,
  fuel_max = 0
where
  class_name like '%old_bike%';

update vehicle set 
  limit_min = 1,
  limit_max = 1
where
  class_name like '%Ural%'
  or class_name like '%V3S%'
  or class_name like '%PBX%'
  or class_name like '%SUV%';

update vehicle set inventory = '[[[], []], [["Skin_Camo1_DZ", "ItemCompass"], [1, 1]], [[], []]]' where class_name = 'ATV_CZ_EP1';
update vehicle set inventory = '[[[], []], [["WeaponHolder_ItemTent", "ItemMatchbox"], [1, 1]], [[], []]]' where class_name = 'ATV_US_EP1';
update vehicle set inventory = '[[["LeeEnfield"], [1]], [["5x_22_LR_17_HMR"], [3]], [[], []]]' where class_name = 'car_hatchback';
update vehicle set inventory = '[[[], []], [["ItemFlashlight", "ItemMap"], [1, 1]], [["DZ_ALICE_Pack_EP1"], [1]]]' where class_name = 'car_sedan';
update vehicle set inventory = '[[[], []], [["WeaponHolder_PartFueltank", "WeaponHolder_PartWheel"], [1, 1]], [[], []]]' where class_name = 'hilux1_civil_3_open';
update vehicle set inventory = '[[[], []], [["WeaponHolder_PartEngine", "WeaponHolder_ItemJerrycan"], [1, 1]], [[], []]]' where class_name = 'hilux1_civil_3_open_EP1';
update vehicle set inventory = '[[[], []], [["WeaponHolder_PartWheel", "ItemSodaCoke"], [1, 3]], [[], []]]' where class_name = 'Ikarus';
update vehicle set inventory = '[[[], []], [["ItemWatch", "ItemSodaPepsi"], [1, 3]], [[], []]]' where class_name = 'Ikarus_TK_CIV_EP1';
update vehicle set inventory = '[[["AK_47_M"], [1]], [["ItemPainkiller"], [1]], [[], []]]' where class_name = 'LandRover_CZ_EP1';
update vehicle set inventory = '[[[], []], [["ItemFlashlightRed"], [1]], [["DZ_Backpack_EP1"], [1]]]' where class_name = 'PBX';
update vehicle set inventory = '[[["Makarov"], [1]], [["FoodCanBakedBeans"], [3]], [[], []]]' where class_name = 'S1203_TK_CIV_EP1';
update vehicle set inventory = '[[["Binocular"], [1]], [[], []], [["CZ_VestPouch_EP1"], [1]]]' where class_name = 'Skoda';
update vehicle set inventory = '[[[], []], [["ItemWatch", "ItemKnife"], [1, 1]], [[], []]]' where class_name = 'SkodaBlue';
update vehicle set inventory = '[[[], []], [["ItemMatchbox", "ItemMap"], [1, 1]], [[], []]]' where class_name = 'SkodaGreen';
update vehicle set inventory = '[[[], []], [["Pipebomb"], [1]], [[], []]]' where class_name = 'SUV_TK_CIV_EP1';
update vehicle set inventory = '[[[], []], [["ItemWire", "WeaponHolder_ItemJerrycan"], [1, 1]], [[], []]]' where class_name = 'Tractor';
update vehicle set inventory = '[[[], []], [["WeaponHolder_ItemJerrycan"], [1]], [[], []]]' where class_name = 'TT650_Ins';
update vehicle set inventory = '[[[], []], [["WeaponHolder_PartWheel"], [1]], [[], []]]' where class_name = 'TT650_TK_CIV_EP1';
update vehicle set inventory = '[[[], []], [["WeaponHolder_PartGeneric"], [1]], [[], []]]' where class_name = 'TT650_TK_EP1';
update vehicle set inventory = '[[[], []], [["HandGrenade_east"], [5]], [[], []]]' where class_name = 'UAZ_RU';
update vehicle set inventory = '[[[], []], [["10Rnd_127x99_m107"], [5]], [[], []]]' where class_name = 'UAZ_Unarmed_TK_CIV_EP1';
update vehicle set inventory = '[[[], []], [["20Rnd_762x51_DMR"], [5]], [[], []]]' where class_name = 'UAZ_Unarmed_TK_EP1';
update vehicle set inventory = '[[[], []], [["30Rnd_556x45_StanagSD"], [5]], [[], []]]' where class_name = 'UAZ_Unarmed_UN_EP1';
update vehicle set inventory = '[[[], []], [["ItemSodaCoke"], [5]], [[], []]]' where class_name = 'UH1H_DZ';
update vehicle set inventory = '[[[], []], [["WeaponHolder_PartWheel", "ItemToolbox", "ItemTankTrap"], [1, 1, 1]], [[], []]]' where class_name = 'UralCivil';
update vehicle set inventory = '[[[], []], [["WeaponHolder_PartVRotor", "ItemMorphine", "FoodCanPasta"], [1, 1, 1]], [[], []]]' where class_name = 'UralCivil2';
update vehicle set inventory = '[[["MR43"], [1]], [["WeaponHolder_PartEngine"], [1]], [[], []]]' where class_name = 'V3S_Civ';
update vehicle set inventory = '[[[], []], [["ItemSodaCoke", "FoodCanBakedBeans"], [3, 3]], [[], []]]' where class_name = 'Volha_1_TK_CIV_EP1';
update vehicle set inventory = '[[[], []], [["ItemSodaPepsi", "FoodCanFrankBeans"], [3, 3]], [[], []]]' where class_name = 'Volha_2_TK_CIV_EP1';
