# pgbench 命令说明
`pgbench -c 15 -t 300 pgbench -r -f test.sql`  
15个session，每个session有300个事务  

`pgbench -c 15 -t 300 -j 5 pgbench -r -f test.sql`  
15个session，每个session有300个事务，有5个线程  

# 维护者
[季朋](www.jipeng.me)  
jipengpro@gmail.com



