-- Provide a list of star-like objects that are 1% rare.

explain analyze
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

