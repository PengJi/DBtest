-- Q11-1
-- join
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	P.objID 
FROM 
	PhotoPrimaryLJ AS P join neighbors AS N on P.objID =N.NeighborObjID and P.objID = N.objID;

