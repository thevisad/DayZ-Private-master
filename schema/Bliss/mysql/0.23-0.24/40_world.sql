update world set max_x = 10200, max_y = 10200 where name = 'panthera2';
update world set max_x = 5100, max_y = 5100 where name = 'utes';
update world set max_x = 14000, max_y = 14000 where name = 'takistan';

insert ignore into world values
  (6, 'fallujah', 10200, 10200),
  (7, 'zargabad', 8000, 8000);
