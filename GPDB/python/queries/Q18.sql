-- Find all objects within 30 arcseconds of one another that have very similar colors: that is where the color ratios u-g, g-r, r-i are less than 0.05m.   
/*
 select	 distinct P.ObjID 			-- count distinct cases (will get min objid)
  From	photoPrimary   P,			-- P is the primary object
Neighbors      N, 			-- N is the neighbor link
photoPrimary   L			-- L is the lens candidate of P
 where P.ObjID = N.ObjID			-- N is a neighbor record
   and L.ObjID = N.NeighborObjID  		-- L is a neighbor of P
   and P.ObjID < L.ObjID 			-- avoid duplicates
   and abs((P.u-P.g)-(L.u-L.g))<0.05 		-- L and P have similar spectra.
   and abs((P.g-P.r)-(L.g-L.r))<0.05
   and abs((P.r-P.i)-(L.r-L.i))<0.05  
   and abs((P.i-P.z)-(L.i-L.z))<0.05;
*/

\o /tmp/Q18.txt

create or replace function fQ18()
returns setof text
as $$
begin
return query explain analyze 
select distinct P.ObjID 
From photoPrimary P,
	Neighbors  N, 		
	photoPrimary L		
where P.ObjID = N.ObjID			
	and L.ObjID = N.NeighborObjID  	
	and P.ObjID < L.ObjID 			
	and abs((P.u-P.g)-(L.u-L.g))<0.05
	and abs((P.g-P.r)-(L.g-L.r))<0.05
	and abs((P.r-P.i)-(L.r-L.i))<0.05  
	and abs((P.i-P.z)-(L.i-L.z))<0.05;
end;
$$ language plpgsql;

select fQ18();
