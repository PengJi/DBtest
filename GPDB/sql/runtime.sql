CREATE TABLE runtime(
tablename varchar(50),
start_time timestamp with time zone,
end_time timestamp with time zone
)
distributed by (tablename);
