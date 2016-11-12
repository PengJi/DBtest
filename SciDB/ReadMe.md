# SciDB自动化导入和查询数据

# 程序说明
* `sudo yum install expect -y`
* `sudo yum install collectl -y`
* scidb导入工具为: accelerated_io_tools  
* 数据文件的存放位置与文件命名均需按照统一的格式，以GalaxyLJ表为例：  
10G表：  
/home/scidb/astronomy_data/10G/GalaxyLJ10_comma.csv  
20G表：  
/home/scidb/astronomy_data/20G/GalaxyLJ20_comma.csv  
以此类推
* 集群中各节点的普通用户为scidb，在安装过程中已经配置为免密钥登陆，而还需要root用户的密码，需要统一配置为相同的密码。
* 主节点可免密钥登陆到各从节点，而从节点不能免密钥登陆到主节点
* 程序运行：`./main.sh`

# 维护者
季朋  
jipeng92@gmail.com
