CREATE TABLE Photoz(
	objID bigint primary key NOT NULL,
	z real NOT NULL,
	zErr real NOT NULL,
	nnCount smallint NOT NULL,
	nnVol real NOT NULL,
	nnIsInside smallint NOT NULL,
	nnObjID bigint NOT NULL,
	nnSpecz real NOT NULL,
	nnFarObjID bigint NOT NULL,
	nnAvgZ real NOT NULL,
	distMod real NOT NULL,
	lumDist real NOT NULL,
	chisq real NOT NULL,
	rnorm real NOT NULL,
	nTemplates int NOT NULL,
	synthU real NOT NULL,
	synthG real NOT NULL,
	synthR real NOT NULL,
	synthI real NOT NULL,
	synthZ real NOT NULL,
	kcorrU real NOT NULL,
	kcorrG real NOT NULL,
	kcorrR real NOT NULL,
	kcorrI real NOT NULL,
	kcorrZ real NOT NULL,
	kcorrU01 real NOT NULL,
	kcorrG01 real NOT NULL,
	kcorrR01 real NOT NULL,
	kcorrI01 real NOT NULL,
	kcorrZ01 real NOT NULL,
	absMagU real NOT NULL,
	absMagG real NOT NULL,
	absMagR real NOT NULL,
	absMagI real NOT NULL,
	absMagZ real NOT NULL
)
-- 普通表
-- appendonly表
-- with (appendonly=TRUE)
-- 压缩表
-- with (appendonly=TRUE,compresslevel=5)
-- 列存储表
-- with (appendonly=TRUE,orientation=COLUMN)
-- 列存储压缩表
-- with (appendonly=TRUE,orientation=COLUMN,compresslevel=5)
distributed by(objID);

