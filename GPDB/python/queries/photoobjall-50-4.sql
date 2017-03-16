-- Q9
explain analyze Select 
	G.objID, G.u, G.g, G.r, G.i, G.z 
from 
	PhotoObjAll50 as G, Star as S 
where 
	G.parentID > 0 and G.parentID = S.parentID;