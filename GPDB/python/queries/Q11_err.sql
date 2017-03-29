-- Find all elliptical galaxies with spectra that have an anomalous emission line.   

select	distinct G.ObjID 		-- return qualifying galaxies
from	Galaxy        as G, 		-- G is the galaxy
	SpecObj		as S, 		-- S is the spectra of galaxy G
 	SpecLine       as L, 		-- L is a line of S
 	specLineNames as LN,		-- the type of line
 	XCRedshift     as XC		-- the template cross-correlation 
where G.ObjID = S.ObjID   		-- connect galaxy to the spectrum 
  and S.SpecObjID = L.SpecObjID	-- L is a line of S
  and S.SpecObjID = XC.SpecObjID 	-- CC is a cross-correlation with templates 
  and XC.tempNo = 8                 	-- Template('Elliptical') -- CC says "el-liptical"
  and L.LineID = LN.value		-- line type is found  
  and LN.Name = 'UNKNOWN'		--       but not identified
  and L.ew > 10			-- a prominent (wide) line
  and S.SpecObjID not in (		-- insist that there are no other lines
select S.SpecObjID		-- that are know and are very close to this one
from   	SpecLine       as L1,	-- L1 is another line 
		specLineNames as LN1	
where S.SpecObjID = L1.SpecObjID 	-- for this object 
  and abs(L.wave - L1.wave) <.01 	-- at nearly the same wavelength
  and L1.LineID = LN1.value		-- line found and
  and LN1.Name != 'UNKNOWN' 		--       it IS identified
);

