-- Q1
explain analyze SELECT 
	objID, cModelMag_g 
FROm 
	GalaxyLJ 
WHERE 
	cModelMag_g between 18 and 19;
