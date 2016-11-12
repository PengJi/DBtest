-- Q5-5
-- reduce the number of where clause
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	g1.objID,g2.objID
FROM 
	GalaxyLJ AS g1 , neighbors AS N , GalaxyLJ AS g2 
WHERE
	g1.objID = N.objID and g2.objID = N.NeighborObjID and
    g1.objID < g2.objID and 
    N.neighborType = 3 and 
    g1.petroRad_u > 0 and 
    g2.petroRad_u > 0 and 
    g1.petroRad_g > 0 and 
    (N.distance <= (g1.petroR50_r + g2.petroR50_r));
