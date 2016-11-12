-- Q10
set lang aql;
set no fetch;
set no timer;
set cusout;

SELECT 
	objID, ra , dec 
FROM 
	PhotoPrimaryLJ 
WHERE 
	ra > 185 and ra < 185.1 AND dec > 15 and dec < 15.1;
