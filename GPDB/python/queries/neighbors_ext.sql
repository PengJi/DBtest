CREATE external TABLE neighbors_20_ext(
    objID bigint ,
    NeighborObjID bigint ,
    distance real ,
    type smallint ,
    neighborType smallint ,
    mode smallint,
    neighborMode SMALLINT 
)
location(
'gpfdist://192.168.100.78:8082/20G/neighbors_20.csv'
)
FORMAT 'CSV' ( DELIMITER ',' null as '');
