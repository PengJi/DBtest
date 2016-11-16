-- Q4
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	colc_g, colc_r 
FROM 
	GalaxyLJ 
WHERE 
	(-0.642788*cx +0.766044 * cy>=0) and (-0.984808 * cx - 0.173648 * cy <0);
