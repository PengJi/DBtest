--  Find quasars with a broad absorption line in their spectra and at least one galaxy within 10 arcseconds. Return both the quasars and the galaxies.   
/*
select Q.ObjID as Quasar_candidate_ID, G.ObjID as Galaxy_ID
from  SpecObj       	as Q, 		-- Q is the specObj of the quasar candidate
      Neighbors	as N,		-- N is the Neighbors list of Q
      Galaxy		as G,		-- G is the nearby galaxy
      SpecClass	as SC,
      SpecLine   	as L, 		-- L is the broad line we are looking for 
      SpecLineNames	as LN 
where Q.SpecClass  = SC.class
  and SC.name  in ('QSO', 'HIZ_QSO') 	-- Spectrum says "QSO"
  and Q.SpecObjID = L.SpecObjID	-- L is a spectral line of Q.
  and L.LineID = LN.value		-- line found and  
  and LN.Name != 'UNKNOWN' 		--      not not identified
  and L.ew < -10			-- but its a prominent absorption line
  and Q.ObjID = N.ObjID		-- N is a neighbor record
  and G.ObjID = N.NeighborObjID  	-- G is a neighbor of Q
  and N.distanceMins < (10.0/60.0);	-- and it is within 10 arcseconds of the Q.
*/

\o /tmp/Q19.txt

create or replace function fQ19()
returns setof text
as $$
begin
return query explain analyze select Q.ObjID as Quasar_candidate_ID, G.ObjID as Galaxy_ID
from  SpecObj       	as Q, 		-- Q is the specObj of the quasar candidate
      Neighbors	as N,		-- N is the Neighbors list of Q
      Galaxy		as G,		-- G is the nearby galaxy
      SpecClass	as SC,
      SpecLine   	as L, 		-- L is the broad line we are looking for 
      SpecLineNames	as LN 
where Q.SpecClass  = SC.class
  and SC.name  in ('QSO', 'HIZ_QSO') 	-- Spectrum says "QSO"
  and Q.SpecObjID = L.SpecObjID	-- L is a spectral line of Q.
  and L.LineID = LN.value		-- line found and  
  and LN.Name != 'UNKNOWN' 		--      not not identified
  and L.ew < -10			-- but its a prominent absorption line
  and Q.ObjID = N.ObjID		-- N is a neighbor record
  and G.ObjID = N.NeighborObjID  	-- G is a neighbor of Q
  and N.distanceMins < (10.0/60.0);	-- and it is within 10 arcseconds of the Q.
end;
$$ language plpgsql;

select fQ19();

/*
tables:

views:

functions:

*/

