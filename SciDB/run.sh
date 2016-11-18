:<<doc
程序入口文件
需要设置各节点root的密码
doc

. ./funs.sh

# 程序启动
echo `date`" program start" >> run.log
echo -e "\033[32;49;1m [program start] \033[39;49;0m"

# 创建目录
createDirFun

# 清空缓存
cleanCacheFun jipeng1008

# 删除之前的表并创建表
echo `date`" start truncate tables" >> run.log
echo -e "\033[32;49;1m [truncate tables] \033[39;49;0m"
echo "[truncate tables]"
sh array.sh
echo `date`" end truncate tables" >> run.log

# 导入表
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

echo -e "\033[32;49;1m [exection done] \033[39;49;0m"
