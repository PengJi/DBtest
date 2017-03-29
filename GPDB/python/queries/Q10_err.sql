-- Find galaxies with spectra that have an equivalent width in Ha >40Å (Ha is the main hydrogen spectral line.)  

select G.ObjID 			-- return qualifying galaxies
 from	Galaxy     as G, 		-- G is the galaxy
	SpecObj    as S, 		-- S is the spectra of galaxy G
 	SpecLine   as L,		-- L is a line of S
	specLineNames as LN		-- the names of the lines
 where G.ObjID = S.ObjID 		-- connect the galaxy to the spectrum 
   and S.SpecObjID = L.SpecObjID	-- L is a line of S.
   and L.LineId = LN.value		-- L is the H alpha line
   and LN.name =  'Ha_6565'   
   and L.ew > 40;			-- H alpha is at least 40 angstroms wide.

