-- For each galaxy in the LRG data set (Luminous Red Galaxy), in 160<right ascension<170, count of galaxies within 30"of it that have a photoZ within 0.05 of that galaxy.

declare binned    	bigint;			 	-- initialized “binned” literal
set     binned = 	dbo.fPhotoFlags('BINNED1') +	-- avoids SQL2K optimizer problem
   		dbo.fPhotoFlags('BINNED2') +
   		dbo.fPhotoFlags('BINNED4') ;
declare blended   	bigint;			 	-- initialized “blended” literal
set     blended = 	dbo.fPhotoFlags('BLENDED');  	-- avoids SQL2K optimizer problem
declare noDeBlend 	bigint;			 	-- initialized “noDeBlend” literal
set     noDeBlend = 	dbo.fPhotoFlags('NODEBLEND'); -- avoids SQL2K optimiz-er problem
declare child     	bigint;			 	-- initialized “child” lit-eral
set     child = 	dbo.fPhotoFlags('CHILD');  	-- avoids SQL2K optimizer problem
declare edge      	bigint;			 	-- initialized “edge” lit-eral
set     edge = 	dbo.fPhotoFlags('EDGE');  	-- avoids SQL2K optimizer problem
declare saturated 	bigint;			 	-- initialized “saturated” literal
set     saturated= 	dbo.fPhotoFlags('SATURATED'); -- avoids SQL2K optimizer prob-lem
select  G.objID, count(*) as pop
from 	Galaxy     as G, 			-- first gravitational lens candidate   
	Neighbors  as N,			-- precomputed list of neighbors
	Galaxy     as U, 			-- a neighbor galaxy of G
	PhotoZ     as GpZ,			-- photoZ of first galaxy
	PhotoZ     as NpZ 			-- photoZ of second galaxy
where  G.objID = N.objID		-- connect G and U via the neighbors table
   and U.objID = N.neighborObjID 	-- so that we know G and U are within 
   and N.objID < N.neighborObjID 	-- 30 arcseconds of one another.
   and G.objID = GpZ.objID 		-- join to photoZ of G
   and U.objID = NpZ.objID 		-- join to photoZ of N
   and G.ra between 160 and 170    	-- restrict search to a part of the sky
   and G.dec between -5 and 5		-- that is in database
   and abs(GpZ.Z - NpZ.Z) < 0.05	-- restrict the photoZ differences
   -- Color cut for an BCG courtesy of James Annis of Fermilab
   and (G.flags & binned) > 0  
   and (G.flags & ( blended + noDeBlend + child)) != blended
   and (G.flags & (edge + saturated)) = 0  
   and  G.petroMag_i > 17.5
   and (G.petroMag_r > 15.5 or G.petroR50_r > 2)
   and (G.g >0 and G.r >0 and G.i >0)
   and ( (   ((G.petroMag_r-G.reddening_r)   < 19.2)
         and ((G.petroMag_r - G.reddening_r) 
 				< (12.38 + (7/3)*( G.g-  G.r ) + 4 *( G.r - G.i ) ) ) 
         and ((abs( G.r - G.i - (G.g - G.r )/4 - 0.18 )) < 0.2)
         and ((G.petroMag_r - G.reddening_r + 
 				2.5*Log10(2*pi()*G.petroR50_r* G.petroR50_r )) < 24.2  ) 
         )
       or (  ((G.petroMag_r - G.reddening_r)       < 19.5                       ) 
          and ((G.r - G.i - (G.g - G.r)/4 - 0.18 ) > (0.45 - 4*( G.g- G.r ) )    )
          and ((G.g - G.r ) > ( 1.35 + 0.25 *( G.r - G.i ) )                     )
          and ((G.petroMag_r - G.reddening_r  + 
 				2.5*Log10(2*pi()*G.petroR50_r* G.petroR50_r )) < 23.3  ) 
        ) )  
group by G.objID;

