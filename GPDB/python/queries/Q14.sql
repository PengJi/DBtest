-- Find stars with multiple measurements that have magnitude variations >0.1.

declare star int;			    	-- initialized “star” literal
set     star = dbo.fPhotoType('Star'); 	-- avoids SQL2K optimizer problem
select s1.objID as ObjID1, s2.objID as ObjID2 -- select object IDs of star and its pair
from   star      as   s1,			-- the primary star
       photoObj  as   s2,			-- the second observation of the star
       neighbors as   N			-- the neighbor record
where s1.objID = N.objID			-- insist the stars are neighbors
  and s2.objID = N.neighborObjID		-- using precomputed neighbors table
  and distanceMins < 0.5/60			-- distance is ½ arc second or less
  and s1.run != s2.run				-- observations are two different runs
  and s2.type = star				-- s2 is indeed a star
  and  s1.u between 1 and 27			-- S1 magnitudes are reasonable
  and  s1.g between 1 and 27
  and  s1.r between 1 and 27
  and  s1.i between 1 and 27
  and  s1.z between 1 and 27
  and  s2.u between 1 and 27			-- S2 magnitudes are reasonable.
  and  s2.g between 1 and 27
  and  s2.r between 1 and 27
  and  s2.i between 1 and 27
  and  s2.z between 1 and 27
  and (    	                       	-- and one of the colors is  different.
           abs(S1.u-S2.u) > .1 + (abs(S1.Err_u) + abs(S2.Err_u))  	
        or abs(S1.g-S2.g) > .1 + (abs(S1.Err_g) + abs(S2.Err_g)) 	
        or abs(S1.r-S2.r) > .1 + (abs(S1.Err_r) + abs(S2.Err_r)) 
        or abs(S1.i-S2.i) > .1 + (abs(S1.Err_i) + abs(S2.Err_i)) 
        or abs(S1.z-S2.z) > .1 + (abs(S1.Err_z) + abs(S2.Err_z)) 
	);

