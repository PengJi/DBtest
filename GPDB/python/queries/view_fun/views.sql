--
CREATE or replace VIEW PhotoPrimary 
----------------------------------------------------------------------
--/H These objects are the primary survey objects. 
--
--/T Each physical object 
--/T on the sky has only one primary object associated with it. Upon 
--/T subsequent observations secondary objects are generated. Since the 
--/T survey stripes overlap, there will be secondary objects for over 10% 
--/T of all primary objects, and in the southern stripes there will be a 
--/T multitude of secondary objects for each primary (i.e. reobservations). 
----------------------------------------------------------------------
AS
SELECT * FROM PhotoObjAll 
    WHERE mode=1;

--
CREATE or replace VIEW Galaxy
---------------------------------------------------------------
--/H The objects classified as galaxies from PhotoPrimary.
--
--/T The Galaxy view contains the photometric parameters (no
--/T redshifts or spectroscopic parameters) measured for
--/T resolved primary objects.
---------------------------------------------------------------
AS
SELECT * 
    FROM PhotoPrimary
    WHERE type = 3;

--
CREATE or replace VIEW PhotoObj
----------------------------------------------------------------------
--/H All primary and secondary objects in the PhotoObjAll table, which contains all the attributes of each photometric (image) object. 
--
--/T It selects PhotoObj with mode=1 or 2.
----------------------------------------------------------------------
AS
SELECT * FROM PhotoObjAll 
	WHERE mode in (1,2);

--
CREATE or replace VIEW Star
--------------------------------------------------------------
--/H The objects classified as stars from PhotoPrimary
--
--/T The Star view essentially contains the photometric parameters
--/T (no redshifts or spectroscopic parameters) for all primary
--/T point-like objects, including quasars.
--------------------------------------------------------------
AS
SELECT * 
    FROM PhotoPrimary
    WHERE type = 6;

--
CREATE or replace VIEW PhotoType
------------------------------------------
--/H Contains the PhotoType enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name, 
	cast(value as int) as value, 
	description
    FROM DataConstants
    WHERE field='PhotoType' AND name != '';

--
CREATE or replace VIEW SpecObj 
---------------------------------------------------------------
--/H A view of Spectro objects that just has the clean spectra.
--
--/T The view excludes QA and Sky and duplicates. Use this as the main
--/T way to access the spectro objects.
---------------------------------------------------------------
AS
SELECT * 
    FROM specObjAll
    WHERE sciencePrimary = 1;

--
CREATE or replace VIEW SpecLine 
---------------------------------------------------------------
--/H A view of SpecLines objects that have been measured
--
--/T The view excludes those SpecLine objects which have category=1,
--/T thus they have not been measured. This is the view you should
--/T use to access the SpecLine data.
---------------------------------------------------------------
AS
SELECT * 
    FROM specLineAll 
    WHERE category=2;

--
CREATE or replace VIEW PhotoFlags
------------------------------------------
--/H Contains the PhotoFlags flag values from DataConstants as binary(8)
------------------------------------------
AS
SELECT 
	name, 
	value, 
	description
    FROM DataConstants
    WHERE field='PhotoFlags' AND name != '';

--
CREATE or replace VIEW SpecClass
------------------------------------------
--/H Contains the SpecClass enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name, 
	--cast(value as int) as value, 
	hex_to_dec(cast(value as varchar)) as value,
	description
    FROM DataConstants
    WHERE field='SpecClass';

--
CREATE or replace VIEW PhotoType
------------------------------------------
--/H Contains the PhotoType enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name, 
	hex_to_dec(cast(value as varchar)) as value,
	description
    FROM DataConstants
    WHERE field='PhotoType';

