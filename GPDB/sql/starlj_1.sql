-- Q12-1
-- reduce where clause
explain analyze SELECT 
	run, camcol, rerun, field, objID, u, g, r, i, z, ra, dec 
FROM 
	StarLJ 
WHERE 
	( u - g > 2.0 or u> 22.3 ) and ( i < 19 );
