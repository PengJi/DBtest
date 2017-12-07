create table t1(                                                    
id int,
tm timestamp    
);

insert into t1 select generate_series(1,100000000),clock_timestamp();   

create table t2(                                                    
id int,
tm timestamp    
);

insert into t2 select generate_series(50000000,100000000),clock_timestamp();

create table t3(                                                    
id int,
tm timestamp    
);

insert into t3 select generate_series(90000000,100000000),clock_timestamp();
