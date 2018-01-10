-- Q2
explain analyze SELECT 
	objID 
FROM 
	Galaxy 
WHERE 
	r < 22 and extinction_r > 0.175;
