/*
--
CREATE FUNCTION fPhotoFlags(@name varchar(40))
-------------------------------------------------------------
--/H Returns the PhotoFlags value corresponding to a name
-------------------------------------------------------------
--/T the photoFlags can be shown with Select * from PhotoFlags 
--/T <br>
--/T Sample call to find photo objects with saturated pixels is
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from photoObj 
--/T <br> where flags & dbo.fPhotoFlags('SATURATED') > 0 
--/T </samp> 
--/T <br> see also fPhotoDescription
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM PhotoFlags
	WHERE name = UPPER(@name)
	)
END
*/

create or replace function fPhotoFlags(name1 varchar(40)) 
returns bigint
as $$
declare res bigint;
begin
	SELECT
	hex_to_dec(cast(value as varchar)) into res
	FROM PhotoFlags
	WHERE name = upper(name1);
	return res;
end;
$$ LANGUAGE plpgsql;

/*
--
create or replace function fGetNearbyObjEq (ra float, dec float, r float)
-------------------------------------------------------------
--/H Given an equatorial point (@ra,@dec), returns table of primary objects
--/H within @r arcmins of the point.  There is no limit on @r. 
-------------------------------------------------------------
--/T <br> ra, dec are in degrees, r is in arc minutes.
--/T <br>There is no limit on the number of objects returned, but there are about 40 per sq arcmin.  
--/T <p> returned table:  
--/T <li> objID bigint NOT NULL       -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br>
--/T Sample call to find all the Galaxies within 3 arcminutes of ra,dec 185,0<br>
--/T <samp> 
--/T <br> select * 
--/T <br> from Galaxy                       as G, 
--/T <br>      dbo.fGetNearbyObjEq(185,0,3) as N
--/T <br> where G.objID = N.objID
--/T </samp> 
--/T <br> see also fGetNearestObjEq, fGetNearbyObjXYZ, fGetNearestObjXYZ
-------------------------------------------------------------
  RETURNS setof 
as $$
	DECLARE d2r float, nx float,ny float,nz float 
begin
	d2r := PI()/180.0;
	if (r<0) RETURN
	nx := COS(dec*d2r)*COS(ra*d2r);
	ny := COS(dec*d2r)*SIN(ra*d2r);
	nz := SIN(dec*d2r);	
	return query SELECT * FROM fGetNearbyObjXYZ(nx,ny,nz,r); 
end;
$$ language plpgsql;

--
create or replace function fGetNearbyObjXYZ(nx float, ny float, nz float, r float)
-------------------------------------------------------------
--/H Returns table of primary objects within @r arcmins of an xyz point (@nx,@ny, @nz).
-------------------------------------------------------------
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin.
--/T <p>returned table:  
--/T <li> objID bigint,               -- Photo primary object identifier
--/T <li> run int NOT NULL,           -- run that observed this object   
--/T <li> camcol int NOT NULL,        -- camera column that observed the object
--/T <li> field int NOT NULL,         -- field that had the object
--/T <li> rerun int NOT NULL,         -- computer processing run that discovered the object
--/T <li> type int NOT NULL,          -- type of the object (3=Galaxy, 6= star, see PhotoType in DBconstants)
--/T <li> cx float NOT NULL,          -- x,y,z of unit vector to this object
--/T <li> cy float NOT NULL,
--/T <li> cz float NOT NULL,
--/T <li> htmID bigint,               -- Hierarchical Trangular Mesh id of this object
--/T <li> distance float              -- distance in arc minutes to this object from the ra,dec.
--/T <br> Sample call to find PhotoObjects within 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select *
--/T <br> from  dbo.fGetNearbyObjXYZ(-.996,-.1,0,5)  
--/T </samp>  
--/T <br>see also fGetNearbyObjEq, fGetNearestObjXYZ, fGetNearestObjXYZ
-------------------------------------------------------------
returns setof
as $$
        DECLARE htmTemp TABLE (
                HtmIdStart bigint,
                HtmIdEnd bigint
        );
	DECLARE lim float;
BEGIN
	INSERT into htmTemp SELECT * FROM fHtmCoverCircleXyz(nx,ny,nz,r)
	SET lim := POWER(2*SIN(RADIANS(r/120)),2);

	IF (r<0) RETURN
	INSERT into proxtab SELECT 
            objID, 
            run,
            camcol,
            field,
            rerun,
            type,
            cx,
            cy,
            cz,
            htmID,
            2*DEGREES(ASIN(sqrt(power(nx-cx,2)+power(ny-cy,2)+power(nz-cz,2))/2))*60 
            FROM htmTemp H  join PhotoPrimary P
                     ON  (P.HtmID BETWEEN H.HtmIDstart AND H.HtmIDend )
           AND power(nx-cx,2)+power(ny-cy,2)+power(nz-cz,2) < lim
        ORDER BY power(nx-cx,2)+power(ny-cy,2)+power(nz-cz,2)  ASC
END;
$$ language plpgsql;
*/

--
create or replace function fPhotoType(name varchar(40))
-------------------------------------------------------------------------------
--/H Returns the PhotoType value, indexed by name (Galaxy, Star,...)
-------------------------------------------------------------------------------
--/T the PhotoType names can be found with 
--/T <br>       Select * from PhotoType 
--/T <br>
--/T Sample call to fPhotoType.
--/T <samp> 
--/T <br> select top 10 *  
--/T <br> from photoObj
--/T <br> where type =  dbo.fPhotoType('Star')
--/T </samp> 
--/T <br> see also fPhotoTypeN
-------------------------------------------------------------
returns setof bigint
AS $$
BEGIN
RETURN query SELECT value
	FROM PhotoType
	WHERE name = UPPER(name);
END;
$$ language plpgsql;

/*
--
CREATE or replace FUNCTION fSpecClass(name varchar(40))
-------------------------------------------------------------------------------
--/H Returns the SpecClass value, indexed by name
-------------------------------------------------------------------------------
--/T the  SpecClass values can be found with 
--/T <br>       Select * from SpecClass 
--/T <br>
--/T Sample call to fSpecClass.
--/T <samp> 
--/T <br> select top 10  *
--/T <br> from SpecObj
--/T <br> where specClass = dbo.fSpecClass('QSO')
--/T </samp> 
--/T <br> see also fSpecClassN
-------------------------------------------------------------
RETURNS setof bigint
AS $$
BEGIN
	SELECT hex_to_dec(cast(value as varchar)) as value
	FROM SpecClass
	WHERE name = UPPER(name);
	return res;
END;
$$ language plpgsql;
*/

-- 
create or replace function fGetUrlExpId(objId bigint)
--------------------------------------------
--/H Returns the URL for an Photo objID.
---------------------------------------------
--/T  <br> returns http://localhost/en/tools/explore/obj.asp?id=2255029915222048
--/T  <br> where localhost is filled in from SiteConstants.WebServerURL.
--/T  <br> sample:<br><samp> select dbo.fGetUrlExpId(2255029915222048) </samp>
--/T  <br> see also fGetUrlNavEq, fGetUrlNavId, fGetUrlExpEq
--------------------------------------------
returns varchar(256)
as $$
	declare WebServerURL varchar(500);
	declare ra float;
	declare dec float;
begin
	ra := 0;
	dec := 0;
	WebServerURL := 'http://localhost/';

	select cast(value as varchar(500)) into WebServerURL
		from SiteConstants where name ='WebServerURL'; 
	select ra, ra into dec,dec
		from PhotoObjAll where objID = objId;
	return WebServerURL || 'tools/explore/obj.asp?id=' || cast(objId as varchar(32));
end;
$$ language plpgsql;

-- 十六进制转换为十进制
create or replace function hex_to_dec(var varchar)
returns setof bigint
as $$
declare str varchar;
begin
	str := substring(var,3);	
	-- return query select x || str::bigint;
	-- return query SELECT CAST(('x' || str) AS bigint);
	return query SELECT CAST(CAST(('x' || CAST(str AS text)) AS bit(64)) AS bigint);
end;
$$ language plpgsql;


create or replace function fQ2()
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
        where ra between 170 and 190
        and dec < 0
        and g+rho between 23 and 25;
    end loop;
end;
$$ language plpgsql;

create or replace function fQ2_10()
returns setof text
as $$
declare rho float;
begin
    for rho in execute
        'select -5*log(R)-2.5*log(PI()) from Galaxy;'
    loop
        raise notice '%', rho;
        return query explain analyze select objID
        from Galaxy_10
        where ra between 170 and 190
        and dec < 0
        and g+rho between 23 and 25;
    end loop;
end;
$$ language plpgsql;

create or replace function fQ2_20()
returns setof text
as $$
declare rho float;
begin
    for rho in execute
        'select -5*log(R)-2.5*log(PI()) from Galaxy;'
    loop
        raise notice '%', rho;
        return query explain analyze select objID
        from Galaxy_20
        where ra between 170 and 190
        and dec < 0
        and g+rho between 23 and 25;
    end loop;
end;
$$ language plpgsql;

create or replace function fQ2_50()
returns setof text
as $$
declare rho float;
begin
    for rho in execute
        'select -5*log(R)-2.5*log(PI()) from Galaxy;'
    loop
        raise notice '%', rho;
        return query explain analyze select objID
        from Galaxy_50
        where ra between 170 and 190
        and dec < 0
        and g+rho between 23 and 25;
    end loop;
end;
$$ language plpgsql;


create or replace function fQ3()
returns setof text
as $$
begin
	return query explain analyze select objID
    	from Galaxy
    	where r < 22 and dered_r> 0.175;
end;
$$ language plpgsql;

create or replace function fQ3_10()
returns setof text
as $$
begin
    return query explain analyze select objID
        from Galaxy_10
        where r < 22 and dered_r> 0.175;
end;
$$ language plpgsql;

create or replace function fQ3_20()
returns setof text
as $$
begin
    return query explain analyze select objID
        from Galaxy_20
        where r < 22 and dered_r> 0.175;
end;
$$ language plpgsql;

create or replace function fQ3_50()
returns setof text
as $$
begin
    return query explain analyze select objID
        from Galaxy_50
        where r < 22 and dered_r> 0.175;
end;
$$ language plpgsql;


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

create or replace function fQ4_10()
returns setof text
as $$
declare rho float;
begin
    for rho in execute
        'select -5*log(R)-2.5*log(PI()) from Galaxy;'
    loop
        raise notice '%', rho;
        return query explain analyze select objID
        from Galaxy_10
        where r + rho < 24
        and (power(q_r,2) + power(u_r,2)) > 0.25;
    end loop;
end;
$$ language plpgsql;

create or replace function fQ4_20()
returns setof text
as $$
declare rho float;
begin
    for rho in execute
        'select -5*log(R)-2.5*log(PI()) from Galaxy;'
    loop
        raise notice '%', rho;
        return query explain analyze select objID
        from Galaxy_20
        where r + rho < 24
        and (power(q_r,2) + power(u_r,2)) > 0.25;
    end loop;
end;
$$ language plpgsql;

create or replace function fQ4_50()
returns setof text
as $$
declare rho float;
begin
    for rho in execute
        'select -5*log(R)-2.5*log(PI()) from Galaxy;'
    loop
        raise notice '%', rho;
        return query explain analyze select objID
        from Galaxy_50
        where r + rho < 24
        and (power(q_r,2) + power(u_r,2)) > 0.25;
    end loop;
end;
$$ language plpgsql;


create or replace function fQ5()
returns setof text
as $$
declare binned bigint;
declare blended bigint;
declare noDeBlend bigint;
declare child bigint;
declare edge bigint;
declare saturated bigint;
begin
binned := fPhotoFlags('BINNED1') +
             fPhotoFlags('BINNED2') +
             fPhotoFlags('BINNED4') ;
blended := fPhotoFlags('BLENDED');
noDeBlend := fPhotoFlags('NODEBLEND');
child := fPhotoFlags('CHILD');
edge := fPhotoFlags('EDGE');
saturated := fPhotoFlags('SATURATED');
    return query explain analyze select objID
    from Galaxy as G
    where (G.flags & binned) > 0
    and (G.flags & ( blended + noDeBlend + child)) != blended
    and (G.flags & (edge + saturated)) = 0
    and (G.petroMag_i > 17.5)
    and (G.petroMag_r > 15.5 OR G.petroR50_r > 2)
    and (G.petroMag_r < 30 and G.g < 30 and G.r < 30 and G.i < 30)
    and (( G.r - G.i - (G.g - G.r)/4 - 0.18) BETWEEN -0.2 AND  0.2 )
    and (( G.r - G.i -(G.g - G.r)/4 -.18) > (0.45 - 4*( G.g - G.r)))
    and ((G.g - G.r) > ( 1.35 + 0.25 *(G.r - G.i)));
end;
$$ language plpgsql;

create or replace function fQ5_10()
returns setof text
as $$
declare binned bigint;
declare blended bigint;
declare noDeBlend bigint;
declare child bigint;
declare edge bigint;
declare saturated bigint;
begin
binned := fPhotoFlags('BINNED1') +
             fPhotoFlags('BINNED2') +
             fPhotoFlags('BINNED4') ;
blended := fPhotoFlags('BLENDED');
noDeBlend := fPhotoFlags('NODEBLEND');
child := fPhotoFlags('CHILD');
edge := fPhotoFlags('EDGE');
saturated := fPhotoFlags('SATURATED');
    return query explain analyze select objID
    from Galaxy_10 as G
    where (G.flags & binned) > 0
    and (G.flags & ( blended + noDeBlend + child)) != blended
    and (G.flags & (edge + saturated)) = 0
    and (G.petroMag_i > 17.5)
    and (G.petroMag_r > 15.5 OR G.petroR50_r > 2)
    and (G.petroMag_r < 30 and G.g < 30 and G.r < 30 and G.i < 30)
    and (( G.r - G.i - (G.g - G.r)/4 - 0.18) BETWEEN -0.2 AND  0.2 )
    and (( G.r - G.i -(G.g - G.r)/4 -.18) > (0.45 - 4*( G.g - G.r)))
    and ((G.g - G.r) > ( 1.35 + 0.25 *(G.r - G.i)));
end;
$$ language plpgsql;

create or replace function fQ5_20()
returns setof text
as $$
declare binned bigint;
declare blended bigint;
declare noDeBlend bigint;
declare child bigint;
declare edge bigint;
declare saturated bigint;
begin
binned := fPhotoFlags('BINNED1') +
             fPhotoFlags('BINNED2') +
             fPhotoFlags('BINNED4') ;
blended := fPhotoFlags('BLENDED');
noDeBlend := fPhotoFlags('NODEBLEND');
child := fPhotoFlags('CHILD');
edge := fPhotoFlags('EDGE');
saturated := fPhotoFlags('SATURATED');
    return query explain analyze select objID
    from Galaxy_20 as G
    where (G.flags & binned) > 0
    and (G.flags & ( blended + noDeBlend + child)) != blended
    and (G.flags & (edge + saturated)) = 0
    and (G.petroMag_i > 17.5)
    and (G.petroMag_r > 15.5 OR G.petroR50_r > 2)
    and (G.petroMag_r < 30 and G.g < 30 and G.r < 30 and G.i < 30)
    and (( G.r - G.i - (G.g - G.r)/4 - 0.18) BETWEEN -0.2 AND  0.2 )
    and (( G.r - G.i -(G.g - G.r)/4 -.18) > (0.45 - 4*( G.g - G.r)))
    and ((G.g - G.r) > ( 1.35 + 0.25 *(G.r - G.i)));
end;
$$ language plpgsql;

create or replace function fQ5_50()
returns setof text
as $$
declare binned bigint;
declare blended bigint;
declare noDeBlend bigint;
declare child bigint;
declare edge bigint;
declare saturated bigint;
begin
binned := fPhotoFlags('BINNED1') +
             fPhotoFlags('BINNED2') +
             fPhotoFlags('BINNED4') ;
blended := fPhotoFlags('BLENDED');
noDeBlend := fPhotoFlags('NODEBLEND');
child := fPhotoFlags('CHILD');
edge := fPhotoFlags('EDGE');
saturated := fPhotoFlags('SATURATED');
    return query explain analyze select objID
    from Galaxy_50 as G
    where (G.flags & binned) > 0
    and (G.flags & ( blended + noDeBlend + child)) != blended
    and (G.flags & (edge + saturated)) = 0
    and (G.petroMag_i > 17.5)
    and (G.petroMag_r > 15.5 OR G.petroR50_r > 2)
    and (G.petroMag_r < 30 and G.g < 30 and G.r < 30 and G.i < 30)
    and (( G.r - G.i - (G.g - G.r)/4 - 0.18) BETWEEN -0.2 AND  0.2 )
    and (( G.r - G.i -(G.g - G.r)/4 -.18) > (0.45 - 4*( G.g - G.r)))
    and ((G.g - G.r) > ( 1.35 + 0.25 *(G.r - G.i)));
end;
$$ language plpgsql;


create or replace function fQ6()
returns setof text
as $$
declare rho float;
begin
    return query explain analyze
    select G.ObjID, G.u, G.g, G.r, G.i, G.z
    from galaxy G, star S
    where G.parentID > 0
    and G.parentID = S.parentID;
end;
$$ language plpgsql;


create or replace function fQ6_10()
returns setof text
as $$
declare rho float;
begin
    return query explain analyze
    select G.ObjID, G.u, G.g, G.r, G.i, G.z
    from galaxy_10 G, star_10 S
    where G.parentID > 0
    and G.parentID = S.parentID;
end;
$$ language plpgsql;


create or replace function fQ6_20()
returns setof text
as $$
declare rho float;
begin
    return query explain analyze
    select G.ObjID, G.u, G.g, G.r, G.i, G.z
    from galaxy_20 G, star_20 S
    where G.parentID > 0
    and G.parentID = S.parentID;
end;
$$ language plpgsql;

create or replace function fQ6_50()
returns setof text
as $$
declare rho float;
begin
    return query explain analyze
    select G.ObjID, G.u, G.g, G.r, G.i, G.z
    from galaxy_50 G, star_50 S
    where G.parentID > 0
    and G.parentID = S.parentID;
end;
$$ language plpgsql;


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
	    count(*) as pop 
	from  star
	where (u+g+r+i+z) < 150   
	group by cast(round(u-g) as int), cast(round(g-r) as int),        
    	cast(round(r-i) as int), cast(round(i-z) as int)
	order by count(*);
end;
$$ language plpgsql;

create or replace function fQ7_10()
returns setof text
as $$
declare rho float;
begin
	return query explain analyze
    select  cast(round(u-g) as int) as UG,
		cast(round(g-r) as int) as GR,
	    cast(round(r-i) as int) as RI,
	    cast(round(i-z) as int) as IZ,
	    count(*) as pop
	from  star_10
	where (u+g+r+i+z) < 150
	group by cast(round(u-g) as int), cast(round(g-r) as int),
    	cast(round(r-i) as int), cast(round(i-z) as int)
	order by count(*);
end;
$$ language plpgsql;

create or replace function fQ7_20()
returns setof text
as $$
declare rho float;
begin
    return query explain analyze
    select  cast(round(u-g) as int) as UG,
        cast(round(g-r) as int) as GR,
        cast(round(r-i) as int) as RI,
        cast(round(i-z) as int) as IZ,
        count(*) as pop
    from  star_20
    where (u+g+r+i+z) < 150
    group by cast(round(u-g) as int), cast(round(g-r) as int),
        cast(round(r-i) as int), cast(round(i-z) as int)
    order by count(*);
end;    
$$ language plpgsql;

create or replace function fQ7_50()
returns setof text
as $$
declare rho float;
begin
    return query explain analyze
    select  cast(round(u-g) as int) as UG,
        cast(round(g-r) as int) as GR,
        cast(round(r-i) as int) as RI,
        cast(round(i-z) as int) as IZ,
        count(*) as pop
    from  star_50
    where (u+g+r+i+z) < 150
    group by cast(round(u-g) as int), cast(round(g-r) as int),
        cast(round(r-i) as int), cast(round(i-z) as int)
    order by count(*);
end;    
$$ language plpgsql;


create or replace function fQ13()
returns setof text
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

create or replace function fQ13_10()
returns setof text
as $$
        declare RightShift12 bigint;
begin
	RightShift12 := power(2,24);
	return query explain analyze
	select (htmID /RightShift12) as htm_8, avg(ra) as ra,
		avg(dec) as dec, count(*) as pop
	from Galaxy_10
 	where (0.7*u - 0.5*g - 0.2*i) < 1.25 and  r < 21.75
	group by (htmID /RightShift12);
end;
$$ language plpgsql;

create or replace function fQ13_20()
returns setof text
as $$
        declare RightShift12 bigint;
begin   
    RightShift12 := power(2,24);
    return query explain analyze
    select (htmID /RightShift12) as htm_8, avg(ra) as ra,
        avg(dec) as dec, count(*) as pop
    from Galaxy_20
    where (0.7*u - 0.5*g - 0.2*i) < 1.25 and  r < 21.75
    group by (htmID /RightShift12); 
end;
$$ language plpgsql;

create or replace function fQ13_50()
returns setof text
as $$
        declare RightShift12 bigint;
begin   
    RightShift12 := power(2,24);
    return query explain analyze
    select (htmID /RightShift12) as htm_8, avg(ra) as ra,
        avg(dec) as dec, count(*) as pop
    from Galaxy_50
    where (0.7*u - 0.5*g - 0.2*i) < 1.25 and  r < 21.75
    group by (htmID /RightShift12); 
end;
$$ language plpgsql;


create or replace function fQ14()
returns setof text
as $$
declare star1 int;
begin
star1 := fPhotoType('Star'); 
return query explain analyze 
select s1.objID as ObjID1, s2.objID as ObjID2
from   star      as   s1,
       photoObj  as   s2,
       neighbors as   N
where s1.objID = N.objID
  and s2.objID = N.neighborObjID
  and s1.run != s2.run
  and s2.type = star1
  and  s1.u between 1 and 27
  and  s1.g between 1 and 27
  and  s1.r between 1 and 27
  and  s1.i between 1 and 27
  and  s1.z between 1 and 27
  and  s2.u between 1 and 27
  and  s2.g between 1 and 27
  and  s2.r between 1 and 27
  and  s2.i between 1 and 27
  and  s2.z between 1 and 27
  and (                                
           abs(S1.u-S2.u) > .1 + (abs(S1.Err_u) + abs(S2.Err_u))  
        or abs(S1.g-S2.g) > .1 + (abs(S1.Err_g) + abs(S2.Err_g)) 
        or abs(S1.r-S2.r) > .1 + (abs(S1.Err_r) + abs(S2.Err_r)) 
        or abs(S1.i-S2.i) > .1 + (abs(S1.Err_i) + abs(S2.Err_i)) 
        or abs(S1.z-S2.z) > .1 + (abs(S1.Err_z) + abs(S2.Err_z)) 
        );
end;
$$ language plpgsql;

create or replace function fQ14_10()
returns setof text
as $$
declare star1 int;
begin
star1 := fPhotoType('Star');
return query explain analyze
select s1.objID as ObjID1, s2.objID as ObjID2
from   star_10      as   s1,
       photoObj_10  as   s2,
       neighbors_10 as   N
where s1.objID = N.objID
  and s2.objID = N.neighborObjID
  and s1.run != s2.run
  and s2.type = star1
  and  s1.u between 1 and 27
  and  s1.g between 1 and 27
  and  s1.r between 1 and 27
  and  s1.i between 1 and 27
  and  s1.z between 1 and 27
  and  s2.u between 1 and 27
  and  s2.g between 1 and 27
  and  s2.r between 1 and 27
  and  s2.i between 1 and 27
  and  s2.z between 1 and 27
  and (
           abs(S1.u-S2.u) > .1 + (abs(S1.Err_u) + abs(S2.Err_u))
        or abs(S1.g-S2.g) > .1 + (abs(S1.Err_g) + abs(S2.Err_g))
        or abs(S1.r-S2.r) > .1 + (abs(S1.Err_r) + abs(S2.Err_r))
        or abs(S1.i-S2.i) > .1 + (abs(S1.Err_i) + abs(S2.Err_i))
        or abs(S1.z-S2.z) > .1 + (abs(S1.Err_z) + abs(S2.Err_z))
        );
end;
$$ language plpgsql;

create or replace function fQ14_20()
returns setof text
as $$
declare star1 int;
begin
star1 := fPhotoType('Star');
return query explain analyze
select s1.objID as ObjID1, s2.objID as ObjID2
from   star_20      as   s1,
       photoObj_20  as   s2,
       neighbors_20 as   N
where s1.objID = N.objID
  and s2.objID = N.neighborObjID
  and s1.run != s2.run
  and s2.type = star1
  and  s1.u between 1 and 27
  and  s1.g between 1 and 27
  and  s1.r between 1 and 27
  and  s1.i between 1 and 27
  and  s1.z between 1 and 27
  and  s2.u between 1 and 27
  and  s2.g between 1 and 27
  and  s2.r between 1 and 27
  and  s2.i between 1 and 27
  and  s2.z between 1 and 27
  and (
           abs(S1.u-S2.u) > .1 + (abs(S1.Err_u) + abs(S2.Err_u))
        or abs(S1.g-S2.g) > .1 + (abs(S1.Err_g) + abs(S2.Err_g))
        or abs(S1.r-S2.r) > .1 + (abs(S1.Err_r) + abs(S2.Err_r))
        or abs(S1.i-S2.i) > .1 + (abs(S1.Err_i) + abs(S2.Err_i))
        or abs(S1.z-S2.z) > .1 + (abs(S1.Err_z) + abs(S2.Err_z))
        );
end;
$$ language plpgsql;

create or replace function fQ14_50()
returns setof text
as $$
declare star1 int;
begin
star1 := fPhotoType('Star');
return query explain analyze
select s1.objID as ObjID1, s2.objID as ObjID2
from   star_50      as   s1,
       photoObj_50  as   s2,
       neighbors_50 as   N
where s1.objID = N.objID
  and s2.objID = N.neighborObjID
  and s1.run != s2.run
  and s2.type = star1
  and  s1.u between 1 and 27
  and  s1.g between 1 and 27
  and  s1.r between 1 and 27
  and  s1.i between 1 and 27
  and  s1.z between 1 and 27
  and  s2.u between 1 and 27
  and  s2.g between 1 and 27
  and  s2.r between 1 and 27
  and  s2.i between 1 and 27
  and  s2.z between 1 and 27
  and (
           abs(S1.u-S2.u) > .1 + (abs(S1.Err_u) + abs(S2.Err_u))
        or abs(S1.g-S2.g) > .1 + (abs(S1.Err_g) + abs(S2.Err_g))
        or abs(S1.r-S2.r) > .1 + (abs(S1.Err_r) + abs(S2.Err_r))
        or abs(S1.i-S2.i) > .1 + (abs(S1.Err_i) + abs(S2.Err_i))
        or abs(S1.z-S2.z) > .1 + (abs(S1.Err_z) + abs(S2.Err_z))
        );
end;
$$ language plpgsql;


create or replace function fQ15()
returns setof text
as $$
begin
return query explain analyze select objID, 
        sqrt( power(rowv,2) + power(colv, 2) ) as velocity,
        fGetUrlExpId(objID) as Url
 from PhotoObj  
 where (power(rowv,2) + power(colv, 2)) between 50 and 1000      
   and rowv >= 0 and colv >=0;
end;
$$ language plpgsql;

create or replace function fQ15_10()
returns setof text
as $$
begin
return query explain analyze select objID,
        sqrt( power(rowv,2) + power(colv, 2) ) as velocity,
        fGetUrlExpId(objID) as Url
	from PhotoObj_10  
	where (power(rowv,2) + power(colv, 2)) between 50 and 1000
		and rowv >= 0 and colv >=0;
end;
$$ language plpgsql;

create or replace function fQ15_20()
returns setof text
as $$
begin
return query explain analyze select objID,
        sqrt( power(rowv,2) + power(colv, 2) ) as velocity,
        fGetUrlExpId(objID) as Url
    from PhotoObj_20
    where (power(rowv,2) + power(colv, 2)) between 50 and 1000
        and rowv >= 0 and colv >=0;
end;
$$ language plpgsql;

create or replace function fQ15_50()
returns setof text
as $$
begin
return query explain analyze select objID,
        sqrt( power(rowv,2) + power(colv, 2) ) as velocity,
        fGetUrlExpId(objID) as Url
    from PhotoObj_50
    where (power(rowv,2) + power(colv, 2)) between 50 and 1000
        and rowv >= 0 and colv >=0;
end;
$$ language plpgsql;


create or replace function fQ16()
returns setof text
as $$
begin
return query explain analyze select count(*) as total,
sum( case when (type=3) then 1 else 0 end) as Galaxies,
sum( case when (type=6) then 1 else 0 end) as Stars,
sum( case when (type not in (3,6)) then 1 else 0 end) as Other
from PhotoPrimary                                        
where (( u - g > 2.0) or (u > 22.3) ) 
        and ( i between 0 and 19 ) 
        and ( g - r > 1.0 ) 
        and ( (r - i < 0.08 + 0.42 * (g - r - 0.96)) or (g - r > 2.26 ) )
        and ( i - z < 0.25 );
end;
$$ language plpgsql;

create or replace function fQ16_10()
returns setof text
as $$
begin
	return query explain analyze select count(*) as total,
		sum( case when (type=3) then 1 else 0 end) as Galaxies,
		sum( case when (type=6) then 1 else 0 end) as Stars,
		sum( case when (type not in (3,6)) then 1 else 0 end) as Other
	from PhotoPrimary_10  
	where (( u - g > 2.0) or (u > 22.3) )
        and ( i between 0 and 19 )
        and ( g - r > 1.0 )
        and ( (r - i < 0.08 + 0.42 * (g - r - 0.96)) or (g - r > 2.26 ) )
        and ( i - z < 0.25 );
end;
$$ language plpgsql;

create or replace function fQ16_20()
returns setof text
as $$
begin
    return query explain analyze select count(*) as total,
        sum( case when (type=3) then 1 else 0 end) as Galaxies,
        sum( case when (type=6) then 1 else 0 end) as Stars,
        sum( case when (type not in (3,6)) then 1 else 0 end) as Other
    from PhotoPrimary_20
    where (( u - g > 2.0) or (u > 22.3) )
        and ( i between 0 and 19 )
        and ( g - r > 1.0 )
        and ( (r - i < 0.08 + 0.42 * (g - r - 0.96)) or (g - r > 2.26 ) )
        and ( i - z < 0.25 );
end;
$$ language plpgsql;

create or replace function fQ16_50()
returns setof text
as $$
begin
    return query explain analyze select count(*) as total,
        sum( case when (type=3) then 1 else 0 end) as Galaxies,
        sum( case when (type=6) then 1 else 0 end) as Stars,
        sum( case when (type not in (3,6)) then 1 else 0 end) as Other
    from PhotoPrimary_50
    where (( u - g > 2.0) or (u > 22.3) )
        and ( i between 0 and 19 )
        and ( g - r > 1.0 )
        and ( (r - i < 0.08 + 0.42 * (g - r - 0.96)) or (g - r > 2.26 ) )
        and ( i - z < 0.25 );
end;
$$ language plpgsql;


create or replace function fQ17()
returns setof text
as $$
declare star1 int;
begin
star1 := fPhotoType('Star'); 
return query explain analyze 
select s1.objID as s1, s2.objID as s2 
from Star S1,
        Neighbors N,
        Star S2
  where S1.objID = N. objID 
    and S2.objID = N.NeighborObjID  
    and N.NeighborType = star1
        and N.Distance < .05
    and (S1.u - S1.g) < 0.4  
        and (S1.g - S1.r) < 0.7
        and (S1.r - S1.i) > 0.4 
    and (S1.i - S1.z) > 0.4;
end;
$$ language plpgsql;

create or replace function fQ17_10()
returns setof text
as $$
declare star1 int;
begin
	star1 := fPhotoType('Star'); 
	return query explain analyze 
	select s1.objID as s1, s2.objID as s2
	from Star_10 S1,
		Neighbors_10 N,
        Star_10 S2
	where S1.objID = N. objID 
		and S2.objID = N.NeighborObjID
	    and N.NeighborType = star1
        and N.Distance < .05
	    and (S1.u - S1.g) < 0.4
        and (S1.g - S1.r) < 0.7
        and (S1.r - S1.i) > 0.4
	    and (S1.i - S1.z) > 0.4;
end;
$$ language plpgsql;

create or replace function fQ17_20()
returns setof text
as $$
declare star1 int;
begin
	star1 := fPhotoType('Star');
	return query explain analyze
	select s1.objID as s1, s2.objID as s2
	from Star_20 S1,
        Neighbors_20 N,
        Star_20 S2
	where S1.objID = N. objID
		and S2.objID = N.NeighborObjID
	    and N.NeighborType = star1
        and N.Distance < .05
    	and (S1.u - S1.g) < 0.4
        and (S1.g - S1.r) < 0.7
        and (S1.r - S1.i) > 0.4
	    and (S1.i - S1.z) > 0.4;
end;
$$ language plpgsql;

create or replace function fQ17_50()
returns setof text
as $$
declare star1 int;
begin
    star1 := fPhotoType('Star');
    return query explain analyze
    select s1.objID as s1, s2.objID as s2
    from Star_50 S1,
        Neighbors_50 N,
        Star_50 S2
    where S1.objID = N. objID
        and S2.objID = N.NeighborObjID
        and N.NeighborType = star1
        and N.Distance < .05
        and (S1.u - S1.g) < 0.4
        and (S1.g - S1.r) < 0.7
        and (S1.r - S1.i) > 0.4
        and (S1.i - S1.z) > 0.4;
end;
$$ language plpgsql;


create or replace function fQ18()
returns setof text
as $$
begin
return query explain analyze 
select distinct P.ObjID 
From photoPrimary P,
        Neighbors  N, 
        photoPrimary L
where P.ObjID = N.ObjID
        and L.ObjID = N.NeighborObjID  
        and P.ObjID < L.ObjID 
        and abs((P.u-P.g)-(L.u-L.g))<0.05
        and abs((P.g-P.r)-(L.g-L.r))<0.05
        and abs((P.r-P.i)-(L.r-L.i))<0.05  
        and abs((P.i-P.z)-(L.i-L.z))<0.05;
end;
$$ language plpgsql;

create or replace function fQ18_10()
returns setof text
as $$
begin
return query explain analyze
select distinct P.ObjID
From photoPrimary_10 P,
        Neighbors_10  N,
        photoPrimary_10 L
where P.ObjID = N.ObjID
        and L.ObjID = N.NeighborObjID
        and P.ObjID < L.ObjID
        and abs((P.u-P.g)-(L.u-L.g))<0.05
        and abs((P.g-P.r)-(L.g-L.r))<0.05
        and abs((P.r-P.i)-(L.r-L.i))<0.05
        and abs((P.i-P.z)-(L.i-L.z))<0.05;
end;
$$ language plpgsql;

create or replace function fQ18_20()
returns setof text
as $$
begin
return query explain analyze
select distinct P.ObjID
From photoPrimary_20 P,
        Neighbors_20  N,
        photoPrimary_20 L
where P.ObjID = N.ObjID
        and L.ObjID = N.NeighborObjID
        and P.ObjID < L.ObjID
        and abs((P.u-P.g)-(L.u-L.g))<0.05
        and abs((P.g-P.r)-(L.g-L.r))<0.05
        and abs((P.r-P.i)-(L.r-L.i))<0.05
        and abs((P.i-P.z)-(L.i-L.z))<0.05;
end;    
$$ language plpgsql;

create or replace function fQ18_50()
returns setof text
as $$
begin
return query explain analyze
select distinct P.ObjID
From photoPrimary_50 P,
        Neighbors_50  N,
        photoPrimary_50 L
where P.ObjID = N.ObjID
        and L.ObjID = N.NeighborObjID
        and P.ObjID < L.ObjID
        and abs((P.u-P.g)-(L.u-L.g))<0.05
        and abs((P.g-P.r)-(L.g-L.r))<0.05
        and abs((P.r-P.i)-(L.r-L.i))<0.05
        and abs((P.i-P.z)-(L.i-L.z))<0.05;
end;    
$$ language plpgsql;


create or replace function fQ20()
returns setof text
as $$
declare binned          bigint;                         -- initialized “binned” literal
declare blended         bigint;                         -- initialized “blended” literal
declare noDeBlend       bigint;                         -- initialized “noDeBlend” literal
declare child           bigint;                         -- initialized “child” lit-eral
declare edge            bigint;                         -- initialized “edge” lit-eral
declare saturated       bigint;                         -- initialized “saturated” literal
begin
binned := fPhotoFlags('BINNED1') +      -- avoids SQL2K optimizer problem
                fPhotoFlags('BINNED2') +
                fPhotoFlags('BINNED4') ;
blended := fPhotoFlags('BLENDED');      -- avoids SQL2K optimizer problem
noDeBlend := fPhotoFlags('NODEBLEND'); -- avoids SQL2K optimiz-er problem
child = fPhotoFlags('CHILD');   -- avoids SQL2K optimizer problem
edge := fPhotoFlags('EDGE');    -- avoids SQL2K optimizer problem
saturated := fPhotoFlags('SATURATED'); -- avoids SQL2K optimizer prob-lem
return query explain analyze select  G.objID, count(*) as pop
from Galaxy     as G,                   -- first gravitational lens candidate   
        Neighbors  as N,                        -- precomputed list of neighbors
        Galaxy     as U,                        -- a neighbor galaxy of G
        PhotoZ     as GpZ,                      -- photoZ of first galaxy
        PhotoZ     as NpZ                       -- photoZ of second galaxy
where  G.objID = N.objID                -- connect G and U via the neighbors table
   and U.objID = N.neighborObjID        -- so that we know G and U are within 
   and N.objID < N.neighborObjID        -- 30 arcseconds of one another.
   and G.objID = GpZ.objID              -- join to photoZ of G
   and U.objID = NpZ.objID              -- join to photoZ of N
   and G.ra between 160 and 170         -- restrict search to a part of the sky
   and G.dec between -5 and 5           -- that is in database
   and abs(GpZ.Z - NpZ.Z) < 0.05        -- restrict the photoZ differences
   and (G.flags & binned) > 0  
   and (G.flags & ( blended + noDeBlend + child)) != blended
   and (G.flags & (edge + saturated)) = 0  
   and  G.petroMag_i > 17.5
   and (G.petroMag_r > 15.5 or G.petroR50_r > 2)
   and (G.g >0 and G.r >0 and G.i >0)
   and ((abs( G.r - G.i - (G.g - G.r )/4 - 0.18 )) < 0.2)
          and ((G.r - G.i - (G.g - G.r)/4 - 0.18 ) > (0.45 - 4*( G.g- G.r ) )    )
          and ((G.g - G.r ) > ( 1.35 + 0.25 *( G.r - G.i ) )                     )
group by G.objID;
end;
$$ language plpgsql;

create or replace function fQ20_10()
returns setof text
as $$
declare binned          bigint;                         -- initialized “binned” literal
declare blended         bigint;                         -- initialized “blended” literal
declare noDeBlend       bigint;                         -- initialized “noDeBlend” literal
declare child           bigint;                         -- initialized “child” lit-eral
declare edge            bigint;                         -- initialized “edge” lit-eral
declare saturated       bigint;                         -- initialized “saturated” literal
begin
binned := fPhotoFlags('BINNED1') +      -- avoids SQL2K optimizer problem
                fPhotoFlags('BINNED2') +
                fPhotoFlags('BINNED4') ;
blended := fPhotoFlags('BLENDED');      -- avoids SQL2K optimizer problem
noDeBlend := fPhotoFlags('NODEBLEND'); -- avoids SQL2K optimiz-er problem
child = fPhotoFlags('CHILD');   -- avoids SQL2K optimizer problem
edge := fPhotoFlags('EDGE');    -- avoids SQL2K optimizer problem
saturated := fPhotoFlags('SATURATED'); -- avoids SQL2K optimizer prob-lem
return query explain analyze select  G.objID, count(*) as pop
from Galaxy_10     as G,                   -- first gravitational lens candidate   
     Neighbors_10  as N,                        -- precomputed list of neighbors
     Galaxy_10     as U,                        -- a neighbor galaxy of G
     PhotoZ     as GpZ,                      -- photoZ of first galaxy
     PhotoZ     as NpZ                       -- photoZ of second galaxy
where  G.objID = N.objID                -- connect G and U via the neighbors table
   and U.objID = N.neighborObjID        -- so that we know G and U are within 
   and N.objID < N.neighborObjID        -- 30 arcseconds of one another.
   and G.objID = GpZ.objID              -- join to photoZ of G
   and U.objID = NpZ.objID              -- join to photoZ of N
   and G.ra between 160 and 170         -- restrict search to a part of the sky
   and G.dec between -5 and 5           -- that is in database
   and abs(GpZ.Z - NpZ.Z) < 0.05        -- restrict the photoZ differences
   and (G.flags & binned) > 0
   and (G.flags & ( blended + noDeBlend + child)) != blended
   and (G.flags & (edge + saturated)) = 0
   and  G.petroMag_i > 17.5
   and (G.petroMag_r > 15.5 or G.petroR50_r > 2)
   and (G.g >0 and G.r >0 and G.i >0)
   and ((abs( G.r - G.i - (G.g - G.r )/4 - 0.18 )) < 0.2)
          and ((G.r - G.i - (G.g - G.r)/4 - 0.18 ) > (0.45 - 4*( G.g- G.r ) )    )
          and ((G.g - G.r ) > ( 1.35 + 0.25 *( G.r - G.i ) )                     )
group by G.objID;
end;
$$ language plpgsql;

create or replace function fQ20_20()
returns setof text
as $$
declare binned          bigint;                         -- initialized “binned” literal
declare blended         bigint;                         -- initialized “blended” literal
declare noDeBlend       bigint;                         -- initialized “noDeBlend” literal
declare child           bigint;                         -- initialized “child” lit-eral
declare edge            bigint;                         -- initialized “edge” lit-eral
declare saturated       bigint;                         -- initialized “saturated” literal
begin
binned := fPhotoFlags('BINNED1') +      -- avoids SQL2K optimizer problem
                fPhotoFlags('BINNED2') +
                fPhotoFlags('BINNED4') ;
blended := fPhotoFlags('BLENDED');      -- avoids SQL2K optimizer problem
noDeBlend := fPhotoFlags('NODEBLEND'); -- avoids SQL2K optimiz-er problem
child = fPhotoFlags('CHILD');   -- avoids SQL2K optimizer problem
edge := fPhotoFlags('EDGE');    -- avoids SQL2K optimizer problem
saturated := fPhotoFlags('SATURATED'); -- avoids SQL2K optimizer prob-lem
return query explain analyze select  G.objID, count(*) as pop
from Galaxy_20     as G,                   -- first gravitational lens candidate   
        Neighbors_20  as N,                        -- precomputed list of neighbors
        Galaxy_20     as U,                        -- a neighbor galaxy of G
        PhotoZ     as GpZ,                      -- photoZ of first galaxy
        PhotoZ     as NpZ                       -- photoZ of second galaxy
where  G.objID = N.objID                -- connect G and U via the neighbors table
   and U.objID = N.neighborObjID        -- so that we know G and U are within 
   and N.objID < N.neighborObjID        -- 30 arcseconds of one another.
   and G.objID = GpZ.objID              -- join to photoZ of G
   and U.objID = NpZ.objID              -- join to photoZ of N
   and G.ra between 160 and 170         -- restrict search to a part of the sky
   and G.dec between -5 and 5           -- that is in database
   and abs(GpZ.Z - NpZ.Z) < 0.05        -- restrict the photoZ differences
   and (G.flags & binned) > 0
   and (G.flags & ( blended + noDeBlend + child)) != blended
   and (G.flags & (edge + saturated)) = 0
   and  G.petroMag_i > 17.5
   and (G.petroMag_r > 15.5 or G.petroR50_r > 2)
   and (G.g >0 and G.r >0 and G.i >0)
   and ((abs( G.r - G.i - (G.g - G.r )/4 - 0.18 )) < 0.2)
          and ((G.r - G.i - (G.g - G.r)/4 - 0.18 ) > (0.45 - 4*( G.g- G.r ) )    )
          and ((G.g - G.r ) > ( 1.35 + 0.25 *( G.r - G.i ) )                     )
group by G.objID;
end;
$$ language plpgsql;

create or replace function fQ20_50()
returns setof text
as $$
declare binned          bigint;                         -- initialized “binned” literal
declare blended         bigint;                         -- initialized “blended” literal
declare noDeBlend       bigint;                         -- initialized “noDeBlend” literal
declare child           bigint;                         -- initialized “child” lit-eral
declare edge            bigint;                         -- initialized “edge” lit-eral
declare saturated       bigint;                         -- initialized “saturated” literal
begin
binned := fPhotoFlags('BINNED1') +      -- avoids SQL2K optimizer problem
                fPhotoFlags('BINNED2') +
                fPhotoFlags('BINNED4') ;
blended := fPhotoFlags('BLENDED');      -- avoids SQL2K optimizer problem
noDeBlend := fPhotoFlags('NODEBLEND'); -- avoids SQL2K optimiz-er problem
child = fPhotoFlags('CHILD');   -- avoids SQL2K optimizer problem
edge := fPhotoFlags('EDGE');    -- avoids SQL2K optimizer problem
saturated := fPhotoFlags('SATURATED'); -- avoids SQL2K optimizer prob-lem
return query explain analyze select  G.objID, count(*) as pop
from Galaxy_50     as G,                   -- first gravitational lens candidate   
        Neighbors_50  as N,                        -- precomputed list of neighbors
        Galaxy_50     as U,                        -- a neighbor galaxy of G
        PhotoZ     as GpZ,                      -- photoZ of first galaxy
        PhotoZ     as NpZ                       -- photoZ of second galaxy
where  G.objID = N.objID                -- connect G and U via the neighbors table
   and U.objID = N.neighborObjID        -- so that we know G and U are within 
   and N.objID < N.neighborObjID        -- 30 arcseconds of one another.
   and G.objID = GpZ.objID              -- join to photoZ of G
   and U.objID = NpZ.objID              -- join to photoZ of N
   and G.ra between 160 and 170         -- restrict search to a part of the sky
   and G.dec between -5 and 5           -- that is in database
   and abs(GpZ.Z - NpZ.Z) < 0.05        -- restrict the photoZ differences
   and (G.flags & binned) > 0
   and (G.flags & ( blended + noDeBlend + child)) != blended
   and (G.flags & (edge + saturated)) = 0
   and  G.petroMag_i > 17.5
   and (G.petroMag_r > 15.5 or G.petroR50_r > 2)
   and (G.g >0 and G.r >0 and G.i >0)
   and ((abs( G.r - G.i - (G.g - G.r )/4 - 0.18 )) < 0.2)
          and ((G.r - G.i - (G.g - G.r)/4 - 0.18 ) > (0.45 - 4*( G.g- G.r ) )    )
          and ((G.g - G.r ) > ( 1.35 + 0.25 *( G.r - G.i ) )                     )
group by G.objID;
end;
$$ language plpgsql;

