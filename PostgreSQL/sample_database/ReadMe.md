#PostgreSQL示例数据库
1. 创建示例数据库  
`createdb testDB`
2. 执行脚本创建表和导入数据   
`source create_load.sh`  
3. dump文件解压`../../MySQL/sample_database/employees_db-full-1.0.6.tar.bz2`
**注意**
导入之前需要处理原始文件，  
比如原始文件中为：*INSERT INTO `dept_manager` VALUES (...)*,  
需要去掉这里的*``*，  
即为: *INSERT INTO `dept_manager` VALUES (...)*。

#联系
[季朋](www.jipeng.me)  
jipeng92@gmail.com
