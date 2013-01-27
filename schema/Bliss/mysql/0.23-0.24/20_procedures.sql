drop procedure if exists `proc_updateSurvivor`;
create procedure `proc_updateSurvivor`(in `p_survivorId` int, in `p_worldspace` varchar(1024), in `p_inventory` varchar(2048), in `p_backpack` varchar(2048), in `p_medical` varchar(1024), in `p_lastAte` int, in `p_lastDrank` int, in `p_survivalTime` int, in `p_model` varchar(255), in `p_humanity` int, in `p_zombieKills` int, in `p_headshots` int, in `p_murders` int, in `p_banditKills` int, in `p_state` varchar(255))
begin
  update
    profile p
    inner join survivor s on s.unique_id = p.unique_id
  set
    p.humanity = if(p_humanity = 0, humanity, humanity + p_humanity)
  where
    s.id = p_survivorId; --

  update survivor set
    zombie_kills = zombie_kills + p_zombieKills,
    headshots = headshots + p_headshots,
    bandit_kills = bandit_kills + p_banditKills,
    survivor_kills = survivor_kills + p_murders,
    state = p_state,
    model = if(p_model = 'any', model, p_model),
    last_ate = if(p_lastAte = -1, 0, last_ate + p_lastAte),
    last_drank = if(p_lastDrank = -1, 0, last_drank + p_lastDrank),
    survival_time = survival_time + p_survivalTime,
    worldspace = if(p_worldspace = '[]', worldspace, p_worldspace),
    medical = if(p_medical = '[]', medical, p_medical),
    backpack = if(p_backpack='[]', backpack, p_backpack),
    inventory = if(p_inventory='[]', inventory, p_inventory)
  where
    id = p_survivorId; --
end;

