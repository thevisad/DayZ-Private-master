alter table spawns
  add column chance decimal(4, 4) unsigned not null default 0;

update spawns
set
  chance = 
    case
      when otype like 'Old_bike%' then 0.95
      when otype rlike 'Tractor|.*car.*' then 0.75
      when otype rlike 'ATV.*|TT650.*' then 0.7
      when otype rlike 'UAZ.*|Skoda.*' then 0.65
      when otype like 'SUV%' then 0.45
      when otype like 'UH1H%' then 0.25
      else 0.55
    end; 
