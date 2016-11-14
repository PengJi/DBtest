-- Q1
explain analyze SELECT 
	objID, cModelMag_g 
FROm 
	Galaxy 
WHERE 
	cModelMag_g between 18 and 19;
