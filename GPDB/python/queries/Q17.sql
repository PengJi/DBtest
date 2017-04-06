-- Find binary stars where at least one of them has the colors of a white dwarf. 
/*
declare star int;			    	-- initialized “star” literal
set     star = dbo.fPhotoType('Star'); 	-- avoids SQL2K optimizer problem
select	s1.objID as s1, s2.objID as s2 	-- return star pairs
from	Star       S1,				-- S1 is the white dwarf
   	Neighbors  N,				-- N is the precomputed neighbors links
   	Star       S2				-- S2 is the second star
  where S1.objID = N. objID 			-- S1 and S2 are neighbors-within 30 arc sec
    and S2.objID = N.NeighborObjID  
    and N.NeighborObjType = star	 	-- and S2 is a star
    and N.DistanceMins < .05			-- the 3 arcsecond test
    and (S1.u - S1.g) < 0.4   		-- and S1 meets Paul Szkody’s color cut for
    and (S1.g - S1.r) < 0.7 			-- white dwarfs.
    and (S1.r - S1.i) > 0.4 
    and (S1.i - S1.z) > 0.4;
*/
\o /tmp/Q17.txt

create or replace function fQ17()
returns setof text
as $$
declare star1 int;			
begin
star1 := fPhotoType('Star'); 
return query explain analyze 
select s1.objID as s1, s2.objID as s2 
from Star S1,		
   	Neighbors N,				
   	Star S2	
  where S1.objID = N. objID 		
    and S2.objID = N.NeighborObjID  
    and N.NeighborObjType = star1	
	and N.DistanceMins < .05			
    and (S1.u - S1.g) < 0.4  
	and (S1.g - S1.r) < 0.7
	and (S1.r - S1.i) > 0.4 
    and (S1.i - S1.z) > 0.4;
end;
$$ language plpgsql;

select fQ17();

/*
tables:

views:
PhotoType

functions:

*/
