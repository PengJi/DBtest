-- Q1-1
-- order by
explain analyze SELECT 
	objID, cModelMag_g 
FROm 
	Galaxy 
WHERE 
	cModelMag_g between 18 and 19
order by 
	objID;
