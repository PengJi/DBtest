-- Find galaxies that are blended with a star and output the deblended galaxy magnitudes. 

/*
select G.ObjID, G.u, G.g, G.r, G.i, G.z  		-- output galaxy and magni-tudes.
from 	galaxy G, star S  				-- for each galaxy
where	G.parentID > 0					-- galaxy has a “parent”
  and  G.parentID = S.parentID;			-- star has the same parent 
*/

-- 输出结果到文件
\o /tmp/Q6.txt

create or replace function fQ6()
returns setof text
as $$
declare rho float;
begin
	return query explain analyze 
	select G.ObjID, G.u, G.g, G.r, G.i, G.z         
	from galaxy G, star S                
	where G.parentID > 0               
	and	G.parentID = S.parentID;       
end;
$$ language plpgsql;

select fQ6();
