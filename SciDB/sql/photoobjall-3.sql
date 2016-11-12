-- Q8
set lang aql;
set no fetch;
set no timer;
set cusout;

Select 
	G.objID, G.u, G.g, G.r, G.i, G.z 
from 
	(SELECT * FROM ( SELECT * FROM PhotoObjAll WHERE mode=1) as p WHERE type = 3) as G, 
	(SELECT * FROM ( SELECT * FROM PhotoObjAll WHERE mode=1) as h) as S 
where 
	G.parentID > 0 and G.parentID = S.parentID;
