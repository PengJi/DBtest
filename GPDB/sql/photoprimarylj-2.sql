-- Q11
explain analyze SELECT 
	P.objID 
FROM 
	PhotoPrimaryLJ AS P,neighbors AS N 
WHERE 
	P.objID = N.objID and P.objID =N.NeighborObjID;
