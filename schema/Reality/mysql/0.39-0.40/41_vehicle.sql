insert ignore INTO `vehicle` (`id`, `class_name`, `limit_min`, `limit_max`, `parts`) VALUES
(95, 'Ka137_DZ', 0, 1, NULL),
(96, 'ibr_as350lingor', 0, 1, NULL),
(97, 'ibr_as350_pmc', 0, 1, NULL),
(98, 'ibr_as350_pol', 0, 1, NULL),
(99, 'JetSkiYanahui_Case_Yellow', 0, 1, NULL),
(100, 'JetSkiYanahui_Case_Green', 0, 1, NULL),
(101, 'JetSkiYanahui_Case_Blue', 0, 1, NULL),
(102, 'JetSkiYanahui_Case_Red', 0, 1, NULL),
(103, 'JetSkiYanahui_Yellow', 0, 1, NULL),
(104, 'JetSkiYanahui_Green', 0, 1, NULL),
(105, 'JetSkiYanahui_Blue', 0, 1, NULL),
(106, 'JetSkiYanahui_Red', 0, 1, NULL);
(107, 'SUV_SpecialSkaro', 0, 1, NULL);

update vehicle set parts='motor,elektronika,mala vrtule,velka vrtule' where id='35';