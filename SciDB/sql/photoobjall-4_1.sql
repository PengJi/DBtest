-- Q9-1
-- join
set lang aql;
set no fetch;
set no timer;
set cusout;

Select 
	G.objID, G.u, G.g, G.r, G.i, G.z 
from 
	PhotoObjAll as G join StarLJ as S on G.parentID = S.parentID 
where
	G.parentID > 0;
