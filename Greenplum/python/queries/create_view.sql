--
CREATE VIEW PhotoPrimary 
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

CREATE VIEW Galaxy
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
CREATE VIEW Star
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
CREATE VIEW SpecObj 
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
