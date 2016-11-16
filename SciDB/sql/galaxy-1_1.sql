-- Q1-1
-- order by
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	objID, cModelMag_g 
FROM
	GalaxyLJ 
WHERE 
	cModelMag_g between 18 and 19
order by
	objID;
