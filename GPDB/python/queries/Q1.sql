-- Find all galaxies without saturated pixels within 1' of a given point.

create or replace function fQ1()
returns bigint
as $$
declare saturated bigint;
begin
saturated := fPhotoFlags('saturated');
select G.objID, GN.distance
from Galaxy as G join fGetNearbyObjEq(185,-0.5, 1) as GN
on G.objID = GN.objID
where (G.flags & saturated) = 0
order by distance;
end;
$$ language plpgsql;

/*
table:
DataConstants

view:

function: 
fPhotoFlags
fGetNearbyObjEq
fGetNearbyObjXYZ
fHtmCoverCircleXyz
*/
