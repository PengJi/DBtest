-- Find galaxies with an isophotal surface brightness (SB) larger than 24 in the red band, with an ellipticity>0.5, and with the major axis of the ellipse between 30” and 60”arc seconds (a large galaxy).

/*
select ObjID -- put the qualifying galaxies in a table
from Galaxy -- select galaxies
where r + rho < 24 -- brighter than magnitude 24 in the red spectral band
and isoA_r between 30 and 60 -- major axis between 30" and 60"
and (power(q_r,2) + power(u_r,2)) > 0.25; -- square of ellipticity is > 0.5 squared.
*/

-- 输出结果到文件
\o /tmp/Q4.txt

create or replace function fQ4()
returns setof text
as $$
declare rho float;
begin
    for rho in execute
        'select -5*log(R)-2.5*log(PI()) from Galaxy;'
    loop
        raise notice '%', rho;
        return query explain analyze select objID
		from Galaxy 
		where r + rho < 24 
		and (power(q_r,2) + power(u_r,2)) > 0.25;
    end loop;
end;
$$ language plpgsql;

select fQ4();
