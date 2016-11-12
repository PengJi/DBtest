-- Q9-2
-- exchange the orde of join
explain analyze Select 
	G.objID, G.u, G.g, G.r, G.i, G.z 
from 
	StarLJ as S join PhotoObjAll as G on G.parentID = S.parentID
where 
	G.parentID > 0;
