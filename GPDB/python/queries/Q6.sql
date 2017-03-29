-- Find galaxies that are blended with a star and output the deblended galaxy magnitudes. 

select G.ObjID, G.u, G.g, G.r, G.i, G.z  		-- output galaxy and magni-tudes.
from 	galaxy G, star S  				-- for each galaxy
where	G.parentID > 0					-- galaxy has a “parent”
  and  G.parentID = S.parentID;			-- star has the same parent 

