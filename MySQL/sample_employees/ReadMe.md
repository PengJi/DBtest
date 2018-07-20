# MySQL示例数据库
[创建示例数据库](https://launchpad.net/test-db/+milestone/1.0.6)  
1. 解压`employees_db-full-1.0.6.tar`  
2. 进入文件夹`employees-db`，有如下文件  
`employees.sql` 创建表并导入数据，这里需要修改文件中dump文件的路径   
`employees_partitioned.sql` 创建分区表,这里需要修改文件中dump文件的路径   
`source employees_partitioned2.sql` 创建分区表，这里需要修改文件dump文件的路径  
`employees_partitioned3.sql` 创建分区表，这里需要修改文件中dump文件的路径  
`object.sql` 创建函数、视图、存储过程  
`test_employees_md5.sql` 测试文件  
`test_employees_sha.sql` 测试文件  
`*.dump` 为数据文件  
3. 创建表并导入数据
`source /home/mydb/employees_db/employees.sql`

# 联系
[季朋](www.jipeng.me)  
jipengpro@gmail.com

