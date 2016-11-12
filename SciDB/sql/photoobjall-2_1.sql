-- Q7-1
-- count()
set lang aql;
set no fetch;
set no timer;
set cusout;

select 
	count(*) 
from 
	PhotoObjAll 
where 
	(r - extinction_r) < 22 and mode =1 and type =3;
