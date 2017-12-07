-- Q7-1
-- count
explain analyze select 
	count(*)
from 
	PhotoObjAll_1 
where 
	(r - extinction_r) < 22 and mode =1 and type =3;
