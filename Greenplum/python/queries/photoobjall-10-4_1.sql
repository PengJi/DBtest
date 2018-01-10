-- Q9-1
-- join
explain analyze Select 
	G.objID, G.u, G.g, G.r, G.i, G.z 
from 
	PhotoObjAll_10 as G join Star_10 as S on G.parentID = S.parentID
where 
	G.parentID > 0;
