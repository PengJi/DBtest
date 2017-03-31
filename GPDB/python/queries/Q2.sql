-- Find all galaxies with blue surface brightness between and 23 and 25 magnitude per square arcseconds, and super galactic latitude (sgb) between (-10º, 10º), and declination less than zero.

/*
select objID
from Galaxy
where ra between 170 and 190
and dec < 0
and g+rho between 23 and 25;
*/

create or replace function fget_objID()
returns bigint
as $$
declare rho float;
declare str text;
begin
	-- select -5*log(R)-2.5*log (PI()) into rho from Galaxy;
	for rho in execute
		'select -5*log(R)-2.5*log (PI()) from Galaxy;'
	loop
		raise notice '%', rho;
		explain analyze select objID
		from Galaxy
		where ra between 170 and 190
		and dec < 0
		and g+rho between 23 and 25 into str;
		raise notice '%',str;
	end loop;
	return 1;
end;
$$ language plpgsql;

select fget_objID();
