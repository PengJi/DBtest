-- Q9-2
-- exchange the orde of join
explain analyze Select 
	G.objID, G.u, G.g, G.r, G.i, G.z 
from 
	Star_20 as S join PhotoObjAll_20 as G on G.parentID = S.parentID
where 
	G.parentID > 0;
