-- Q7
explain analyze select 
	objID 
from 
	PhotoObjAll_50 
where 
	(r - extinction_r) < 22 and mode =1 and type =3;
