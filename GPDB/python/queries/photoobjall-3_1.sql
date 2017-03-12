-- Q8-1
-- join
explain analyze Select 
	G.objID, G.u, G.g, G.r, G.i, G.z 
from 
	(SELECT * FROM ( SELECT * FROM PhotoObjAll WHERE mode=1) as p WHERE type = 3) as G join
	(SELECT * FROM ( SELECT * FROM PhotoObjAll WHERE mode=1) as h) as S on G.parentID = S.parentID
where 
	G.parentID > 0;
