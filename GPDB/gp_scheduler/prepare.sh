# 添加访问控制
echo "host    all all 0.0.0.0/0   trust" >> /home/gpdba/gpdata/master/gpseg-1/pg_hba.conf 
# 重新加载配置
gpstop -u

# 创建 resource group
psql -d testDB -c "CREATE RESOURCE GROUP rg_scheduler_test WITH (concurrency=3, cpu_rate_limit=20, memory_limit=20)";

# 创建 role
psql -d testDB -c "create role tenant1 createdb createrole createexttable inherit login encrypted password 'tenant1' resource group rg_scheduler_test;";
psql -d testDB -c "create role tenant2 createdb createrole createexttable inherit login encrypted password 'tenant2' resource group rg_scheduler_test;";
psql -d testDB -c "create role tenant3 createdb createrole createexttable inherit login encrypted password 'tenant3' resource group rg_scheduler_test;";


