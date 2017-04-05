-- Find all objects with unclassified spectra.  

/*
 declare unknown bigint;			 	-- initialized “binned” literal
 set    unknown = dbo.fSpecClass('UNKNOWN')  
 select specObjID
 from   SpecObj
 where  SpecClass = unknown;
*/

declare unknown bigint
unknown := fSpecClass('UNKNOWN')  
select specObjID
from   SpecObj
where  SpecClass = unknown;

/*
tables:
specObjAll

views:
SpecObj

functions:

*/
