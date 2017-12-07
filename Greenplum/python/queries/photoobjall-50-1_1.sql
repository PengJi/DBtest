-- Q6-1
-- order by
explain analyze select 
	objID,ra,dec 
from 
	PhotoObjAll_50 
where 
	mode<=2 and ra>335 and ra<338.3 and dec>-1 and dec<1
order by
	objID;
