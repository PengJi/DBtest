-- Q11
explain analyze SELECT 
	P.objID 
FROM 
	PhotoPrimary AS P,neighbors AS N 
WHERE 
	P.objID = N.objID and P.objID =N.NeighborObjID;
