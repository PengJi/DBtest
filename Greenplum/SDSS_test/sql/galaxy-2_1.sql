-- Q2-1
-- count
explain analyze SELECT 
	count(*)
FROM 
	Galaxy 
WHERE 
	r < 22 and extinction_r > 0.175;
