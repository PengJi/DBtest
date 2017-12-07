CREATE TABLE neighbors(
	objID bigint NOT NULL,
	NeighborObjID bigint NOT NULL,
	distance real NULL,
	type smallint NOT NULL,
	neighborType smallint NOT NULL,
	mode smallint NOT NULL,
	neighborMode SMALLINT NOT NULL
)
-- 普通表
-- appendonly表
-- with (appendonly=TRUE)
-- with (appendonly=TRUE,compresslevel=5)
distributed by(objID);
