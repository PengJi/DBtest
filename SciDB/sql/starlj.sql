-- Q12
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	run, camcol, rerun, field, objID, u, g, r, i, z, ra, dec 
FROM 
	StarLJ 
WHERE 
	( u - g > 2.0 or u> 22.3 ) and ( i < 19 ) and 
	( i > 0 ) and ( g - r > 1.0 ) and 
	( r - i < (0.08 + 0.42 * (g - r - 0.96)) or g - r > 2.26 ) and ( i - z < 0.25 );
