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

create or replace function fPhotoFlags(name varchar(40)) 
returns setof bigint
as $$
begin
	return query SELECT cast(value as bigint)
	FROM PhotoFlags
	WHERE name = name;
end;
$$ LANGUAGE plpgsql;

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

--
CREATE or replace FUNCTION fPhotoFlags(name varchar(40))
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
RETURNS setof bytea
AS $$
BEGIN
RETURN query SELECT value
	FROM PhotoFlags
	WHERE name = UPPER(name);
END;
$$ language plpgsql;

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
returns setof int
AS $$
BEGIN
RETURN query SELECT value
	FROM PhotoType
	WHERE name = UPPER(name);
END;
$$ language plpgsql;

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
RETURNS setof bytea
AS $$
BEGIN
RETURN query SELECT value 
	FROM SpecClass
	WHERE name = UPPER(name);
END;
$$ language plpgsql;

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

create or replace function hex_to_dec(var varchar)
returns setof bigint
as $$
declare str varchar;
begin
	str := substring(var,3);	
	-- return query select x || str::bigint;
	-- return query SELECT CAST(('x' || str) AS bigint);
	return query SELECT CAST(CAST(('x' || CAST($1 AS text)) AS bit(64)) AS bigint);
end;
$$ language plpgsql;

