-- Q9
set lang aql;
set no fetch;
set no timer;
set cusout;

Select 
	G.objID, G.u, G.g, G.r, G.i, G.z 
from 
	PhotoObjAll as G, StarLJ as S 
where G.parentID > 0 and G.parentID = S.parentID;
