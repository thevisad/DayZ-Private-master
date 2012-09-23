update spawns set otype = 'V3S_Civ' where otype = 'V3S_Gue';
update objects set otype = 'V3S_Civ' where otype = 'V3S_Gue';

update spawns set chance = 0.25 where otype = 'UH1H_DZ' and chance = 0;
