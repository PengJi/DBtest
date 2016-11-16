-- Q2-1
-- count()
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	count(*) 
FROM 
	GalaxyLJ 
WHERE 
	r < 22 and extinction_r > 0.175;
