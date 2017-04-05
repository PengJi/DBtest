-- Find all galaxies without saturated pixels within 1' of a given point.

declare saturated bigint;
set saturated = fPhotoFlags('saturated');
select G.objID, GN.distance
from Galaxy as G join fGetNearbyObjEq(185,-0.5, 1) as GN
on G.objID = GN.objID
where (G.flags & saturated) = 0
order by distance;
