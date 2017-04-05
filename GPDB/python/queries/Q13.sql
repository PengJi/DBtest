-- Create a count of galaxies for each of the HTM triangles which satisfy a certain color cut, like 0.7u-0.5g-0.2i<1.25  and r<21.75, output it in a form adequate for visualization. 

/*
declare RightShift12 bigint;
set     RightShift12 = power(2,24);
select (htmID /RightShift12) as htm_8, -- group by 8-deep HTMID (rshift HTM by 12)
avg(ra)  as ra, 
avg(dec) as [dec], 
count(*) as pop		-- return center point and count for display
 into  ##results			-- put the answer in the results set.
 from 	Galaxy				-- only look at galaxies
 where  (0.7*u - 0.5*g - 0.2*i) < 1.25 	-- meeting this color cut
   and  r < 21.75			-- fainter than 21.75 magnitude in red band.
 group by (htmID /RightShift12); 	-- group into 8-deep HTM buckets..HTM buckets
*/
\o /tmp/Q13.sql

create or replace function fQ13()
returns table(a float,b float,c float,d bigint)
as $$
	declare RightShift12 bigint;
begin
	RightShift12 := power(2,24);
	return query explain analyze 
	select (htmID /RightShift12) as htm_8, avg(ra) as ra, 
	avg(dec) as dec, count(*) as pop
	from Galaxy
	where (0.7*u - 0.5*g - 0.2*i) < 1.25 and  r < 21.75
	group by (htmID /RightShift12);
end;
$$ language plpgsql;

select fQ13();
/*
tables:

views:
Galaxy

functions:
*/
