:<<doc
需要修改的参数:
主节点名: JPDB2
从节点名: node1/node2/node3/node4/node5/node6
doc

# 导入文件
. ./funs.sh

# 删除旧文件
delQueryResFun

# 查询表
queryTableFun

# 汇总结果
colResFun ./rec_query

# 执行完毕
echo `date`" Query Operation Completed" >> run.log
echo -e "\033[32;49;1m [Query Operation Completed] \033[39;49;0m"
