-- Find all galaxies with a deVaucouleours profile (r¼ falloff of intensity on disk) and the photometric colors consistent with an elliptical galaxy.

/*
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
declare edge     	bigint;			 	-- initialized “edge” lit-eral
set     edge = 	dbo.fPhotoFlags('EDGE');  	-- avoids SQL2K optimizer problem
declare saturated 	bigint;			 	-- initialized “saturated” literal
set     saturated = 	dbo.fPhotoFlags('SATURATED'); -- avoids SQL2K optimiz-er problem
select objID
from Galaxy as G 		-- count galaxies
where	lDev_r > 1.1 * lExp_r	-- red DeVaucouleurs fit likelihood greater than disk fit  -- 删除
   and 	lExp_r > 0		-- exponential disk fit likelihood in red band > 0  -- 删除
   -- Color cut for an elliptical galaxy courtesy of James Annis of Fermilab
   and (G.flags & binned) > 0  
   and (G.flags & ( blended + noDeBlend + child)) != blended
   and (G.flags & (edge + saturated)) = 0  
   and (G.petroMag_i > 17.5)
   and (G.petroMag_r > 15.5 OR G.petroR50_r > 2)
   and (G.petroMag_r < 30 and G.g < 30 and G.r < 30 and G.i < 30)
   and ((G.petroMag_r-G.reddening_r) < 19.2)  -- 删除
   and (   (     ((G.petroMag_r - G.reddening_r) < (13.1 +  -- deRed_r < 13.1 +  -- 删除
                                       (7/3)*(G.g - G.r) + 	-- 0.7 / 0.3 * deRed_gr
                                4 *(G.r - G.i) -4 * 0.18 )) -- 1.2 / 0.3 * deRed_ri          
             and (( G.r - G.i - (G.g - G.r)/4 - 0.18) BETWEEN -0.2 AND  0.2 ) 
            )
         or 
  	    (     (( G.petroMag_r - G.reddening_r) < 19.5 )	-- deRed_r < 19.5 +  -- 删除
             and (( G.r - G.i -(G.g - G.r)/4 -.18) >    	-- cperp = deRed_ri             
                         (0.45 - 4*( G.g - G.r)))  		-- 0.45 - deRed_gr/0.25
             and ((G.g - G.r) > ( 1.35 + 0.25 *(G.r - G.i)))          
       )    );
*/

\o /tmp/Q5.txt

create or replace function fQ5()
returns setof text
as $$
declare binned bigint;			 	
declare blended bigint;			 	
declare noDeBlend bigint;			 
declare child bigint;			 
declare edge bigint;	
declare saturated bigint;		
begin
binned := fPhotoFlags('BINNED1') +	
   			 fPhotoFlags('BINNED2') +
   			 fPhotoFlags('BINNED4') ;
blended := fPhotoFlags('BLENDED');  
noDeBlend := fPhotoFlags('NODEBLEND'); 
child := fPhotoFlags('CHILD');  
edge := fPhotoFlags('EDGE');  
saturated := fPhotoFlags('SATURATED');
	return query explain analyze select objID
	from Galaxy as G 		
	where (G.flags & binned) > 0  
	and (G.flags & ( blended + noDeBlend + child)) != blended
	and (G.flags & (edge + saturated)) = 0  
	and (G.petroMag_i > 17.5)
	and (G.petroMag_r > 15.5 OR G.petroR50_r > 2)
	and (G.petroMag_r < 30 and G.g < 30 and G.r < 30 and G.i < 30)
	and (( G.r - G.i - (G.g - G.r)/4 - 0.18) BETWEEN -0.2 AND  0.2 )
	and (( G.r - G.i -(G.g - G.r)/4 -.18) > (0.45 - 4*( G.g - G.r))) 
	and ((G.g - G.r) > ( 1.35 + 0.25 *(G.r - G.i)));
end;
$$ language plpgsql;

select fQ5();

/*
functions:
fPhotoFlags

tables:
DataConstants

views:
PhotoFlags
*/
