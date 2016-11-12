:<<doc
程序入口
doc

. ./funs.sh

echo -e "\033[35;49;1m [program start] \033[39;49;0m"
echo "************************************program start**************************************" >> run.log

# 创建存放结果的目录
mkdir ./1G
mkdir ./10G
mkdir ./20G
mkdir ./50G

# 导入和查询1G数据
for k in $(seq 1 5 )
do
	./run.sh 1
	mv ./rec_load ./rec_load-${k}
	mv ./rec_query ./rec_query-${k}
	mv ./rec_load-${k} ./1G
	mv ./rec_query-${k} ./1G
done

# 导入和查询10G数据
for k in $(seq 1 5 )
do
	./run.sh 10
	mv ./rec_load ./rec_load-${k}
	mv ./rec_query ./rec_query-${k}
	mv ./rec_load-${k} ./10G
	mv ./rec_query-${k} ./10G
done

# 导入和查询20G数据
for k in $(seq 1 5 )
do  
	./run.sh 20
	mv ./rec_load ./rec_load-${k}
	mv ./rec_query ./rec_query-${k}
	mv ./rec_load-${k} ./20G
	mv ./rec_query-${k} ./20G
done

# 导入和查询50G数据
for k in $(seq 1 5 )
do  
	./run.sh 50
	mv ./rec_load ./rec_load-${k}
	mv ./rec_query ./rec_query-${k}
	mv ./rec_load-${k} ./50G
	mv ./rec_query-${k} ./50G
done

# 删除表
#delTable
# 清空缓存
cleanCacheFun

echo -e "\033[35;49;1m [program end] \033[39;49;0m"
echo "************************************program end**************************************" >> run.log
