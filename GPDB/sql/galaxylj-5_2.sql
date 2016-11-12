-- Q5-2
-- add count function
explain analyze SELECT 
	COUNT(*) 
FROM 
	GalaxyLJ AS g1 JOIN neighbors AS N ON g1.objID = N.objID JOIN GalaxyLJ AS g2 ON g2.objID = N.NeighborObjID 
WHERE
	g1.objID < g2.objID and N.neighborType = 3 and g1.petroRad_u > 0 and g2.petroRad_u > 0 and g1.petroRad_g > 0 and 
	g2.petroRad_g > 0 and g1.petroRad_r > 0 and g2.petroRad_r > 0 and g1.petroRad_i > 0 and g2.petroRad_i > 0 and 
	g1.petroRad_z > 0 and g2.petroRad_z > 0 and g1.petroRadErr_g > 0 and g2.petroRadErr_g > 0 and g1.petroMag_g>=16 and 
	g1.petroMag_g<=21 and g2.petroMag_g>=16 and g2.petroMag_g<=21 and g1.modelMag_u > -9999 and g1.modelMag_g > -9999 and
	g1.modelMag_r > -9999 and g1.modelMag_i > -9999 and g1.modelMag_z > -9999 and g2.modelMag_u > -9999 and 
	g2.modelMag_g > -9999 and g2.modelMag_r > -9999 and g2.modelMag_i > -9999 and g2.modelMag_z > -9999 and 
	(g1.modelMag_g - g2.modelMag_g > 3 or g1.modelMag_g - g2.modelMag_g < -3) and (g1.petroR50_r>=0.25*g2.petroR50_r AND 
	g1.petroR50_r<=4.0*g2.petroR50_r) and (g2.petroR50_r>=0.25*g1.petroR50_r AND g2.petroR50_r<=4.0*g1.petroR50_r) and 
	(N.distance <= (g1.petroR50_r + g2.petroR50_r));
