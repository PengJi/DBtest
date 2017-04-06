create table DataConstants(
	filed varchar(128),
	name varchar(128),
	value bytea,
	description varchar(2000)
)
distributed by(filed,name);
