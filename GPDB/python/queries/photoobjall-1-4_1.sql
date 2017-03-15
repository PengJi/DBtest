-- Q9-1
-- join
explain analyze Select 
	G.objID, G.u, G.g, G.r, G.i, G.z 
from 
	PhotoObjAll1 as G join Star as S on G.parentID = S.parentID
where 
	G.parentID > 0;
