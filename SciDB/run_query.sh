:<<doc
需要修改的参数:
主节点名: JPDB1
从节点名: worker1/worker2/worker3/worker4/worker5/worker6
doc

. ./funs.sh

# 删除旧文件
delQueryResFun

# 查询表
queryTableFun

# 汇总结果
colResFun scidb ./rec_query

# 执行完毕
echo `date`" Query Operation Completed" >> run.log
echo -e "\033[32;49;1m [Query Operation Completed] \033[39;49;0m"
