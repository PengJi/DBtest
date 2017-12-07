-- Find all galaxies brighter than magnitude 22, where the local extinction is >0.175.
/*
select objID
from Galaxy
where r < 22
and reddening_r> 0.175;
*/

\o /tmp/Q3.txt

create or replace function fQ3()
returns setof text
as $$
begin
	raise notice '%', 'Q3';
	return query explain analyze select objID
	from Galaxy
	where r < 22
	and dered_r> 0.175;
end;
$$ language plpgsql;

select fQ3();
