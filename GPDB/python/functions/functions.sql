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
as $$
begin
  RETURNS setof 
  AS BEGIN
	DECLARE d2r float, nx float,ny float,nz float 
	set d2r = PI()/180.0
	if (r<0) RETURN
			set nx  = COS(dec*d2r)*COS(ra*d2r)
	set ny  = COS(dec*d2r)*SIN(ra*d2r)
	set nz  = SIN(dec*d2r)
	INSERT proxtab	
	return query SELECT * FROM fGetNearbyObjXYZ(nx,ny,nz,r) 
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
BEGIN
        DECLARE htmTemp TABLE (
                HtmIdStart bigint,
                HtmIdEnd bigint
        );

        INSERT into htmTemp SELECT * FROM fHtmCoverCircleXyz(nx,ny,nz,r)
        DECLARE lim float;
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
CREATE FUNCTION fPhotoFlags(name varchar(40))
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
RETURNS setof 
AS $$
BEGIN
RETURN query SELECT cast(value as bigint)
	FROM PhotoFlags
	WHERE name = UPPER(name)
END;
$$ language plpgsql;


