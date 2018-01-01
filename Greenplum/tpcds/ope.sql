-- 创建group
create resource group tenant_group with(
	concurrency=20,
	cpu_rate_limit=60,
	memory_limit=60
);

drop resource group tenant_group;

-- 创建role
create role tenant createdb createrole createexttable inherit login encrypted password 'tenant' resource group tenant_group;

-- 赋权
grant all on 
call_center,
catalog_page,
catalog_returns,
catalog_sales,
customer,
customer_address,
customer_demographics,
date_dim,
dbgen_version,
household_demographics,
income_band,
inventory,
item,
promotion,
reason,
ship_mode,
store,
store_returns,
store_sales,
time_dim,
warehouse,
web_page,
web_returns,
web_sales,
web_site
to tenant;


