-- Create a grided count of galaxies with u-g>1 and r<21.5 over -5<declination<5, and 175<right ascen-sion<185, on a grid of 2’ arc minutes.  Create a map of masks over the same grid. 

--- First find the grided galaxy count (with the color cut)
--- In local tangent plane, ra/cos(dec) is a “linear” degree.

declare LeftShift16 bigint;		-- used to convert 20-deep htmIds to 6-deep IDs
set     LeftShift16 = power(2,28);
select cast((ra/cos(cast(dec*30 as int)/30.0))*30 as int)/30.0 as raCosDec, 
       cast(dec*30 as int)/30.0                                as dec, 
       count(*)                                                as pop
from   Galaxy as G , 
       dbo.fHTM_Cover('CONVEX J2000 6 6 175 -5 175 5 185 5 185 -5') as T
where  htmID between T.HTMIDstart*LeftShift16 and T. HTMIDend*LeftShift16
  and  ra between 175 and 185
  and  dec between -5 and 5
  and  u-g > 1
  and  r < 21.5
group by  cast((ra/cos(cast(dec*30 as int)/30.0))*30 as int)/30.0, 
          cast(dec*30 as int)/30.0;

