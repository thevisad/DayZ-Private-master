insert into vehicle values
  (92,'MH6J_DZ',0.1,0.5,0,0.5,0,1,'motor,elektronika,mala vrtule,velka vrtule','[[[],[]],[["1Rnd_Smoke_M203", "7Rnd_45ACP_1911", "30Rnd_556x45_StanagSD", "200Rnd_556x45_M249", "FoodCanPasta", "15Rnd_W1866_Slug", "5x_22_LR_17_HMR", "15Rnd_9x19_M9SD", "17Rnd_9x19_glock17", "100Rnd_762x51_M240", "6Rnd_45ACP", "8Rnd_9x18_Makarov"],[]],[["DZ_Backpack_EP1"],[]]]'),
  (93,'HMMWV',0.3,0.9,0.3,0.7,0,5,'palivo,motor,karoserie,wheel_1_1_steering,wheel_1_2_steering,wheel_2_1_steering,wheel_2_2_steering','[[["AK_47_M"],[]],[["PartWoodPile", "ItemBandage", "HandGrenade_west", "6Rnd_45ACP", "ItemEpinephrine", "8Rnd_B_Beneli_74Slug", "HandChemBlue", "8Rnd_B_Beneli_Pellets", "PartEngine", "17Rnd_9x19_glock17", "ItemTent"],[]],[["DZ_CivilBackpack_EP1"],[]]]');

update vehicle set parts = null where parts = '[]' or parts = '';
