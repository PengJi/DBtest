:<<doc
程序入口文件
运行之前需要安装: sudo yum install expect -y
需要各节点root的密码
todo
自动删除结果文件
doc

# 引用文件
. ./funs.sh

# 程序启动
echo `date`" program start" >> run.log
echo -e "\033[32;49;1m [program start] \033[39;49;0m"

# 创建目录
createDirFun

# 清空节点缓存缓存
# 传入参数：各节点root用户的密码
cleanCacheFun jipeng1008

# 清空表
truncateTableFun

# 导入表
# 传入参数：导入的文件大小
echo -e "\033[32;49;1m [load tables] \033[39;49;0m"
echo `date`" start load tables" >> run.log
sh run_load.sh $1
echo `date`" end load tables" >> run.log

# 中场休息~
sleep 2

# 查询表
echo `date`" start query tables" >> run.log
echo -e "\033[32;49;1m [query tables] \033[39;49;0m"
sh run_query.sh
echo `date`" end query tables" >> run.log

echo -e "\033[32;49;1m [program exection done] \033[39;49;0m"
