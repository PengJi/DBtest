-- Q11-2
-- exchange the order of join
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	P.objID 
FROM 
	neighbors AS N join PhotoPrimaryLJ AS P on P.objID =N.NeighborObjID and P.objID = N.objID; 

