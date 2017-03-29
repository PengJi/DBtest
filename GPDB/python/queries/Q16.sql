-- Find all objects similar to the colors of a quasar at 5.5<redshift<6.5. 

select count(*) 					 as 'total', 	
sum( case when (type=3) then 1 else 0 end) 		 as 'Galaxies',
sum( case when (type=6) then 1 else 0 end) 		 as 'Stars',
sum( case when (type not in (3,6)) then 1 else 0 end) as 'Other'
from 	PhotoPrimary				-- for each object		 		
 where (( u - g > 2.0) or (u > 22.3) ) 	-- apply the quasar color cut.
   and ( i between 0 and 19 ) 
   and ( g - r > 1.0 ) 
   and ( (r - i < 0.08 + 0.42 * (g - r - 0.96)) or (g - r > 2.26 ) )
   and 	( i - z < 0.25 );

