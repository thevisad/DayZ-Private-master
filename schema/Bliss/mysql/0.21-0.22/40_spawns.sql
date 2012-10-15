update vehicle set limit_max = ceiling(rand() * 5) where limit_max = 0;

update vehicle set inventory = replace(inventory, 'WeaponHolder_', '');
