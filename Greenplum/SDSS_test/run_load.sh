:<<doc
需要修改的参数：
导入表的大小：10、20、50、100
主节点名: JPDB2
从节点名: node1/node2/node3/node4/node5/node6
doc

# 包含文件
. ./funs.sh

# 删除旧文件
delLoadResFun

# 导入表
loadTable $1

# 得到表的大小
getTabeSizeFun

# 汇总结果
colResFun ./rec_load

# 操作完成
echo `date`" Load Operation Completed" >> run.log
echo -e "\033[32;49;1m [Load Operation Completed] \033[39;49;0m"
