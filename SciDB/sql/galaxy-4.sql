-- Q4
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	g,run,rerun,camcol,field,objID 
FROM 
	GalaxyLJ 
WHERE 
	( (g <= 22) and (u - g >= -0.27) and 
	(u - g < 0.71) and (g - r >= -0.24) and 
	(g - r < 0.35) and (r - i >= -0.27) and 
	(r - i < 0.57) and (i - z >= -0.35) and 
	(i - z < 0.70) );
