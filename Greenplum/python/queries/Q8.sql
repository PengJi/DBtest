-- Find all objects with unclassified spectra.  

/*
 declare unknown bigint;			 	-- initialized “binned” literal
 set    unknown = dbo.fSpecClass('UNKNOWN')  
 select specObjID
 from   SpecObj
 where  SpecClass = unknown;
*/

\o /tmp/Q8.txt

create or replace function fQ8()
returns setof text
as $$
declare unknown bigint;
begin
unknown := fSpecClass('UNKNOWN'); 
return query explain analyze select specObjID
from   SpecObj
where  SpecClass = unknown;
end;
$$ language plpgsql;

select fQ8();

/*
tables:
specObjAll

views:
SpecObj

functions:

*/
