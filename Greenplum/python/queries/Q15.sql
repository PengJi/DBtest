-- Provide a list of moving objects consistent with an asteroid.  
/*
 select	objID,  					       -- return object ID
 	sqrt( power(rowv,2) + power(colv, 2) ) as velocity, -– velocity
	dbo.fGetUrlExpId(objID) as Url		       -- url of image to examine it.
 from	PhotoObj  					       -- check each object.
 where (power(rowv,2) + power(colv, 2)) between 50 and 1000	-- square of veloci-ty 
   and rowv >= 0 and colv >=0;				    -- negative values in-dicate error
*/

\o /tmp/Q15.txt

create or replace function fQ15()
returns setof text
as $$
begin
return query explain analyze select objID, 
 	sqrt( power(rowv,2) + power(colv, 2) ) as velocity,
	fGetUrlExpId(objID) as Url	
 from PhotoObj  					
 where (power(rowv,2) + power(colv, 2)) between 50 and 1000	 
   and rowv >= 0 and colv >=0;
end;
$$ language plpgsql;

select fQ15();

/*
tables:
SiteConstants
PhotoObjAll

views:
PhotoObj

functions:
fGetUrlExpId

*/
