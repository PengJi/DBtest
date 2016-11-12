:<<doc
需要修改的参数：
表名:    astronomy
主节点名: JPDB1
从节点名: worker1/worker2/worker3/worker4/worker5/worker6
doc

. ./funs.sh

# 删除旧文件
delLoadResFun

# 导入表，参数可以是10、20、50
loadTable $1

# 汇总结果
# 主节点scidb用户的密码
colResFun scidb ./rec_load

# 操作完成
echo `date`" Load Operation Complete" >> run.log
echo -e "\033[32;49;1m [Load Operation Complete] \033[39;49;0m"
