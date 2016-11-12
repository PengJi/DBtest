:<<doc
辅助函数:
createDirFun --创建存放结果的目录
cleanCacheFun jipeng1008 --清空集群中各节点的缓存
delLoadResFun --删除旧的导入结果文件
delQueryResFun --删除旧的查询结果文件
delTable --删除表
loadTable 10 --导入所有表
loadGalaxyLJFun 10 --导入GalaxyLJ表
loadPhotoObjAllFun 10 --导入单个表
loadPhotoPrimaryLJFun 10 --导入单个表
loadStarLJFun 10 --导入单个表
loadneighborsFun 10 --导入单个表
queryTableFun --查询表
colResFun scidb ./rec_load --汇总结果
doc

# 创建存放结果的目录
createDirFun(){
	echo `date`" mkdir" >> run.log
	echo -e "\033[32;49;1m [create dir] \033[39;49;0m"
	if [ -d "./rec_load" ]; then
    	rm -rf ./rec_load
	fi
	if [ -d "./rec_query" ]; then
    	rm -rf ./rec_query
	fi
	mkdir ./rec_load
	mkdir ./rec_query
}

# 清空集群中各个节点的缓存
# 参数:
# 集群中为各节点root的密码,存在默认密码为
cleanCacheFun(){
    if [ -n "${1}" ]; then
        passwd="$1"
    else
        passwd="jipeng1008"
    fi
	echo `date`" start clear cache" >> run.log
	echo -e "\033[32;49;1m [clear cache] \033[39;49;0m"
expect << exp
spawn su
expect "assword:"
send "${passwd}\r"
expect "#"
send "sync\r"
send "echo 1 > /proc/sys/vm/drop_caches\r"
send  "exit\r"
expect eof
exp

for k in $(seq 1 6)
do
echo `date`" clear worker${k} cache" >> run.log
expect << exp
spawn ssh root@worker${k}
expect "assword:"
send "${passwd}\r"
expect "#"
send "sync\r"
send "echo 1 > /proc/sys/vm/drop_caches\r"
send  "exit\r"
expect eof
exp
done
echo `date`" end clear cache" >> run.log
}

# 删除旧的导入结果文件
delLoadResFun(){
	echo `date`" deleting monitor files" >> run.log
	echo -e "\033[33;49;1m [deleting monitor files] \033[39;49;0m"
	if [ -f "/tmp/monitor.txt" ]; then
    	rm /tmp/monitor.txt
	fi
	if [ -f "./rec_load/galaxylj.txt" ]; then
    	rm ./rec_load/galaxylj.txt
	fi
	if [ -f "./rec_load/photoobjall.txt" ]; then
    	rm ./rec_load/photoobjall.txt
	fi
	if [ -f "./rec_load/photoprimarylj.txt" ]; then
    	rm ./rec_load/photoprimarylj.txt
	fi
	if [ -f "./rec_load/starlj.txt" ]; then
    	rm ./rec_load/starlj.txt
	fi
	if [ -f "./rec_load/neighbors.txt" ]; then
    	rm ./rec_load/neighbors.txt
	fi

for k in $(seq 1 6)
do
ssh scidb@worker${k} << eof
if [ -f "/tmp/monitor${k}.txt" ]; then
    rm /tmp/monitor${k}.txt
fi
eof
done
}

# 删除旧的查询结果文件
delQueryResFun(){
	echo `date`" deleting monitor files" >> run.log
	echo -e "\033[33;49;1m [deleting monitor files] \033[39;49;0m"
	if [ -f "/tmp/monitor.txt" ]; then
    	rm /tmp/monitor.txt
	fi
	if [ -f "./rec_query/galaxylj.txt" ]; then
    	rm ./rec_query/galaxylj.txt
	fi
	if [ -f "./rec_query/photoobjall.txt" ]; then
    	rm ./rec_query/photoobjall.txt
	fi
	if [ -f "./rec_query/photoprimarylj.txt" ]; then
    	rm ./rec_query/photoprimarylj.txt
	fi
	if [ -f "./rec_query/starlj.txt" ]; then
    	rm ./rec_query/starlj.txt
	fi

for k in $(seq 1 6)
do
ssh scidb@worker${k} << eof
    if [ -f "/tmp/monitor${k}.txt" ]; then
        rm /tmp/monitor${k}.txt
    fi
eof
done
}

# 删除表
delTable(){
	echo -e "\033[32;49;1m [remove array] \033[39;49;0m"
	iquery -q "remove(GalaxyLJ)";
	iquery -q "remove(PhotoObjAll)";
	iquery -q "remove(PhotoPrimaryLJ)";
	iquery -q "remove(StarLJ)";
	iquery -q "remove(neighbors)";
}

# 导入GalaxyLJ表
# 参数:
# 数据大小: 10、20、50、100
loadGalaxyLJFun(){
    sh ./monitor/load_monitor_start.sh
    echo `date`" loading galaxylj" >> run.log
    echo -e "\033[32;49;1m [loading galaxylj] \033[39;49;0m"
    sleep 2
    echo "load GalaxyLJ time:" > ./rec_load/galaxylj.txt
    iquery -aq "set no fetch;load(GalaxyLJ ,'/home/scidb/astronomy_data/"$1"G/GalaxyLJ"$1"_comma.csv',-2, 'CSV');" >> ./rec_load/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# 导入PhotoObjAll表
# 参数:
# 数据大小: 10、20、50、100
loadPhotoObjAllFun(){
    sh ./monitor/load_monitor_start.sh
    echo `date`" loading photoobjall" >> run.log
    echo -e "\033[32;49;1m [loading photoobjall] \033[39;49;0m"
    sleep 2
    echo "load PhotoObjAll time:" > ./rec_load/photoobjall.txt
    iquery -aq "set no fetch;load(PhotoObjAll ,'/home/scidb/astronomy_data/"$1"G/PhotoObjAll"$1"_comma.csv', -2, 'CSV');" >> ./rec_load/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# 导入PhotoPrimaryLJ表
# 参数:
# 数据大小: 10、20、50、100
loadPhotoPrimaryLJFun(){
    sh ./monitor/load_monitor_start.sh
    echo `date`" loading photoprimarylj" >> run.log
    echo -e "\033[32;49;1m [loading photoprimarylj] \033[39;49;0m"
    sleep 2
    echo "load photoprimarylj time:" > ./rec_load/photoprimarylj.txt
    iquery -aq "set no fetch;load(PhotoPrimaryLJ ,'/home/scidb/astronomy_data/"$1"G/PhotoPrimaryLJ"$1"_comma.csv', -2, 'CSV');" >> ./rec_load/photoprimarylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# 导入StarLJ表
# 参数:
# 数据大小: 10、20、50、100
loadStarLJFun(){
    sh ./monitor/load_monitor_start.sh
    echo `date`" loading starlj" >> run.log
    echo -e "\033[32;49;1m [loading starlj] \033[39;49;0m"
    sleep 2
    echo "load starlj time:" > ./rec_load/starlj.txt
    iquery -aq "set no fetch;load(StarLJ ,'/home/scidb/astronomy_data/"$1"G/StarLJ"$1"_comma.csv', -2,'CSV');" >> ./rec_load/starlj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# 导入neighbors表
# 参数:
# 数据大小: 10、20、50、100
loadneighborsFun(){
    sh ./monitor/load_monitor_start.sh 
    echo `date`" loading neighbors" >> run.log
    echo -e "\033[32;49;1m [loading neighbors] \033[39;49;0m"
    sleep 2
    echo "load neighbors time:" > ./rec_load/neighbors.txt
    iquery -aq "set no fetch;load(neighbors ,'/home/scidb/astronomy_data/"$1"G/neighbors"$1"_comma.csv' ,-2, 'CSV');" >> ./rec_load/neighbors.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# 导入所有表
# 参数:
# 数据大小: 10、20、50、100
loadTable(){
	# 导入GalaxyLJ
	loadGalaxyLJFun $1

	# 导入PhotoOboAll
	loadPhotoObjAllFun $1

	# 导入PhotoPrimaryLJ
	loadPhotoPrimaryLJFun $1

	# 导入StarLJ
	loadStarLJFun $1 

	# 导入neighbors
	loadneighborsFun $1
}

# Q1
queryGalaxylj_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-1] \033[39;49;0m"
    sleep 2
    echo `date`"Q1" >> run.log 
    echo "Q1" >> ./rec_query/galaxylj.txt
    iquery  -f "./sql/galaxylj-1.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q1-1
queryGalaxylj_1_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-1_1] \033[39;49;0m"
    sleep 2
    echo `date`" Q1-1" >> run.log 
    echo "Q1-1" >> ./rec_query/galaxylj.txt
    iquery  -f "./sql/galaxylj-1_1.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q2
queryGalaxylj_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-2] \033[39;49;0m"
    sleep 2
    echo `date`" Q2" >> run.log
    echo "Q2" >> ./rec_query/galaxylj.txt
    iquery -f "./sql/galaxylj-2.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q2-1
queryGalaxylj_2_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-2_!] \033[39;49;0m"
    sleep 2
    echo `date`" Q2-1" >> run.log
    echo "Q2-1" >> ./rec_query/galaxylj.txt
    iquery -f "./sql/galaxylj-2_1.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q3
queryGalaxylj_3(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-3] \033[39;49;0m"
    sleep 2
    echo `date`" Q3" >> run.log
    echo "Q3" >> ./rec_query/galaxylj.txt
    iquery -f "./sql/galaxylj-3.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q4
queryGalaxylj_4(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-4] \033[39;49;0m"
    sleep 2
    echo `date`" Q4" >> run.log
    echo "Q4" >> ./rec_query/galaxylj.txt
    iquery -f "./sql/galaxylj-4.sql" >> ./rec_query/galaxylj.txt 
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5
queryGalaxylj_5(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-5] \033[39;49;0m"
    sleep 2
    echo `date`" Q5" >> run.log
    echo "Q5" >> ./rec_query/galaxylj.txt
    #iquery -f "./sql/galaxylj-5.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-1
queryGalaxylj_5_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-5_1] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-1" >> run.log
    echo "Q5-1" >> ./rec_query/galaxylj.txt
    #iquery -f "./sql/galaxylj-5_1.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-2
queryGalaxylj_5_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-5_2] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-2" >> run.log
    echo "Q5-2" >> ./rec_query/galaxylj.txt
    #iquery -f "./sql/galaxylj-5_2.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-3
queryGalaxylj_5_3(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-5_3] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-3" >> run.log
    echo "Q5-3" >> ./rec_query/galaxylj.txt
    iquery -f "./sql/galaxylj-5_3.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-4
queryGalaxylj_5_4(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-5_4] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-4" >> run.log
    echo "Q5-4" >> ./rec_query/galaxylj.txt
    iquery -f "./sql/galaxylj-5_4.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-5
queryGalaxylj_5_5(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxylj-5_5] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-5" >> run.log
    echo "Q5-5" >> ./rec_query/galaxylj.txt
    iquery -f "./sql/galaxylj-5_5.sql" >> ./rec_query/galaxylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q6
queryPhotoobjall_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoobjall-1] \033[39;49;0m"
    sleep 2
	echo `date`" Q6" >> run.log
    echo "Q6" >> ./rec_query/photoobjall.txt
    iquery -f "./sql/photoobjall-1.sql" >> ./rec_query/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q6-1
queryPhotoobjall_1_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoobjall-1_1] \033[39;49;0m"
    sleep 2
	echo `date`" Q6-1" >> run.log
    echo "Q6-1" >> ./rec_query/photoobjall.txt
    iquery -f "./sql/photoobjall-1_1.sql" >> ./rec_query/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q7
queryPhotoobjall_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoobjall-2] \033[39;49;0m"
    sleep 2
    echo `date`" Q7" >> run.log
    echo "Q7" >> ./rec_query/photoobjall.txt
    iquery -f "./sql/photoobjall-2.sql" >> ./rec_query/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q7-1
queryPhotoobjall_2_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoobjall-2_1] \033[39;49;0m"
    sleep 2
    echo `date`" Q7-1" >> run.log
    echo "Q7-1" >> ./rec_query/photoobjall.txt
    iquery -f "./sql/photoobjall-2_1.sql" >> ./rec_query/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q8
queryPhotoobjall_3(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoobjall-3] \033[39;49;0m"
    sleep 2
    echo `date`" Q8" >> run.log
    echo "Q8" >> ./rec_query/photoobjall.txt
    iquery -f "./sql/photoobjall-3.sql" >> ./rec_query/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q8-1
queryPhotoobjall_3_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoobjall-3_1] \033[39;49;0m"
    sleep 2
    echo `date`" Q8-1" >> run.log
    echo "Q8-1" >> ./rec_query/photoobjall.txt
    #iquery -f "./sql/photoobjall-3_1.sql" >> ./rec_query/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q9
queryPhotoobjall_4(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoobjall-4] \033[39;49;0m"
    sleep 2
    echo `date`" Q9" >> run.log
    echo "Q9" >> ./rec_query/photoobjall.txt
    iquery -f "./sql/photoobjall-4.sql" >> ./rec_query/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q9-1
queryPhotoobjall_4_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoobjall-4_1] \033[39;49;0m"
    sleep 2
    echo `date`" Q9-1" >> run.log
    echo "Q9-1" >> ./rec_query/photoobjall.txt
    #iquery -f "./sql/photoobjall-4_1.sql" >> ./rec_query/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q9-2
queryPhotoobjall_4_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoobjall-4_2] \033[39;49;0m"
    sleep 2
    echo `date`" Q9-2" >> run.log
    echo "Q9-2" >> ./rec_query/photoobjall.txt
    #iquery -f "./sql/photoobjall-4_2.sql" >> ./rec_query/photoobjall.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q10
queryPhotoprimarylj_1(){
    sh ./monitor/monitor_start.sh
    sleep 2
    echo -e "\033[32;49;1m [querying photoprimarylj-1] \033[39;49;0m"
    echo `date`" Q10" >> run.log
    echo "Q10" >> ./rec_query/photoprimarylj.txt
    iquery -f "./sql/photoprimarylj-1.sql" >> ./rec_query/photoprimarylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q11
queryPhotoprimarylj_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoprimarylj-2] \033[39;49;0m"
    sleep 2
    echo `date`" Q11" >> run.log
    echo "Q11" >> ./rec_query/photoprimarylj.txt
    iquery -f "./sql/photoprimarylj-2.sql" >> ./rec_query/photoprimarylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q11-1
queryPhotoprimarylj_2_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoprimarylj-2_1] \033[39;49;0m"
    sleep 2
	echo `date`" Q11-1" >> run.log
    echo "Q11-1" >> ./rec_query/photoprimarylj.txt
    #iquery -f "./sql/photoprimarylj-2_1.sql" >> ./rec_query/photoprimarylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q11-2
queryPhotoprimarylj_2_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoprimarylj-2_2] \033[39;49;0m"
    sleep 2
	echo `date`" Q11-2" >> run.log
    echo "Q11-2" >> ./rec_query/photoprimarylj.txt
    #iquery -f "./sql/photoprimarylj-2_2.sql" >> ./rec_query/photoprimarylj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q12
queryStarlj_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying starlj] \033[39;49;0m"
    sleep 2
    echo `date`" Q12" >> run.log
    echo "Q12" >> ./rec_query/starlj.txt
    iquery -f "./sql/starlj.sql" >> ./rec_query/starlj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q12-1
queryStarlj_1_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying starlj_1_1] \033[39;49;0m"
    sleep 2
    echo `date`" Q12-1" >> run.log
    echo "Q12-1" >> ./rec_query/starlj.txt
    iquery -f "./sql/starlj_1.sql" >> ./rec_query/starlj.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# 表查询
queryTableFun(){
	cleanCacheFun
	queryGalaxylj_1

	cleanCacheFun
	queryPhotoobjall_1

	cleanCacheFun
	queryPhotoprimarylj_1

	cleanCacheFun
	queryStarlj_1

	cleanCacheFun
	queryGalaxylj_2

	cleanCacheFun
	queryPhotoobjall_2

	cleanCacheFun
	queryPhotoprimarylj_2

	cleanCacheFun
	queryGalaxylj_3

	cleanCacheFun
	queryPhotoobjall_3

	cleanCacheFun
	queryGalaxylj_4

	cleanCacheFun
	queryPhotoobjall_4

	cleanCacheFun
	queryGalaxylj_5

    cleanCacheFun
    queryGalaxylj_1_1

    cleanCacheFun
    queryGalaxylj_2_1

    cleanCacheFun
    queryGalaxylj_5_1

    cleanCacheFun
    queryGalaxylj_5_2

    cleanCacheFun
    queryGalaxylj_5_3

    cleanCacheFun
    queryGalaxylj_5_4

    cleanCacheFun
    queryGalaxylj_5_5

    cleanCacheFun
    queryPhotoobjall_1_1

    cleanCacheFun
    queryPhotoobjall_2_1

    cleanCacheFun
    queryPhotoobjall_3_1

    cleanCacheFun
    queryPhotoobjall_4_1

    cleanCacheFun
    queryPhotoobjall_4_2

    cleanCacheFun
    queryPhotoprimarylj_2_1

    cleanCacheFun
    queryPhotoprimarylj_2_2

    cleanCacheFun
    queryStarlj_1_1
}

# 汇总结果
# 参数1：
# 主节点scidb用户密码：scidb
# 参数2：
# 要汇总的目录：./rec_load、./rec_query
colResFun(){
	echo `date`" scp files" >> run.log
	echo -e "\033[32;49;1m [scp files] \033[39;49;0m"
for k in $(seq 1 6)
do
echo `date`" worker${k} scp" >> run.log
echo -e "\033[33;49;1m [worker${k} scp] \033[39;49;0m"
ssh scidb@worker${k} << eof
if [ -f "/tmp/monitor${k}.txt" ]; then
expect << exp
	set timeout -1
	spawn scp -o StrictHostKeyChecking=no /tmp/monitor${k}.txt scidb@JPDB1:/tmp 
	expect "assword:"
	send "$1\r"
	expect eof
exp
fi
eof
done
	mv /tmp/monitor.txt /tmp/monitor1.txt /tmp/monitor2.txt /tmp/monitor3.txt /tmp/monitor4.txt /tmp/monitor5.txt /tmp/monitor6.txt $2
}

