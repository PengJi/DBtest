-- Q11-2
-- exchange the order of join
explain analyze SELECT 
	P.objID 
FROM 
	neighbors AS N join PhotoPrimaryLJ AS P on P.objID =N.NeighborObjID and P.objID = N.objID;
