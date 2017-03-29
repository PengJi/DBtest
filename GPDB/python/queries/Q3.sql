-- Find all galaxies brighter than magnitude 22, where the local extinction is >0.175.

select objID
from Galaxy
where r < 22
and reddening_r> 0.175;
