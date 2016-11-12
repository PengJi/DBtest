-- Q2
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	objID 
FROM 
	GalaxyLJ 
WHERE 
	r < 22 and extinction_r > 0.175;
