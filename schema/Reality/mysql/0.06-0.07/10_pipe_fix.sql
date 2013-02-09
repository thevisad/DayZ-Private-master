update main set pos = replace(pos, '|', ','), inventory = replace(inventory, '|', ','), backpack = replace(backpack, '|', ','), medical = replace(medical, '|', ','), state = replace(state, '|', ',');
update objects set pos = replace(pos, '|', ','), inventory = replace(inventory, '|', ','), health = replace(health, '|', ',');
update instances set loadout = replace(loadout, '|', ',');

alter table main
  modify medical varchar(255) not null default '[false,false,false,false,false,false,false,12000,[],[0,0],0]',
  modify state varchar(128) not null default '["","aidlpercmstpsnonwnondnon_player_idlesteady04",36]';


