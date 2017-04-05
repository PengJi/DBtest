-- Provide a list of star-like objects that are 1% rare.

/*
select	cast(round((u-g),0) as int) as UG, 
	cast(round((g-r),0) as int) as GR, 
	cast(round((r-i),0) as int) as RI, 
	cast(round((i-z),0) as int) as IZ,
	count(*)                    as pop 
from  star
where (u+g+r+i+z) < 150   -- exclude bogus magnitudes (== 999)
group by	cast(round((u-g),0) as int), cast(round((g-r),0) as int), 
 	cast(round((r-i),0) as int), cast(round((i-z),0) as int)
order by count(*);
*/

-- 输出结果到文件
\o /tmp/Q7.txt

create or replace function fQ7()
returns setof text
as $$
declare rho float;
begin
	return query explain analyze 
	select  cast(round(u-g) as int) as UG,     
    cast(round(g-r) as int) as GR,     
    cast(round(r-i) as int) as RI,     
    cast(round(i-z) as int) as IZ,
    count(*)                    as pop 
	from  star
	where (u+g+r+i+z) < 150   
	group by cast(round(u-g) as int), cast(round(g-r) as int),        
    cast(round(r-i) as int), cast(round(i-z) as int)
	order by count(*);
end;
$$ language plpgsql;

select fQ7();
