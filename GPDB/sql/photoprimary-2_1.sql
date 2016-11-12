-- Q11-1
-- join
explain analyze SELECT 
	P.objID 
FROM 
	PhotoPrimaryLJ AS P join neighbors AS N on P.objID =N.NeighborObjID and P.objID = N.objID;
