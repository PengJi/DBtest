:<<doc
辅助函数:
createDirFun --创建存放结果的目录
cleanCacheFun jipeng1008 --清空集群中各节点的缓存
delLoadResFun --删除旧的导入结果文件
delQueryResFun --删除旧的查询结果文件
delTable --删除表
loadTable 10 --导入所有表
loadGalaxyFun 10 --导入Galaxy表
loadPhotoObjAllFun 10 --导入单个表
loadPhotoPrimaryFun 10 --导入单个表
loadStarFun 10 --导入单个表
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
	if [ -f "./rec_load/galaxy.txt" ]; then
    	rm ./rec_load/galaxy.txt
	fi
	if [ -f "./rec_load/photoobjall.txt" ]; then
    	rm ./rec_load/photoobjall.txt
	fi
	if [ -f "./rec_load/photoprimary.txt" ]; then
    	rm ./rec_load/photoprimary.txt
	fi
	if [ -f "./rec_load/star.txt" ]; then
    	rm ./rec_load/star.txt
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
	if [ -f "./rec_query/galaxy.txt" ]; then
    	rm ./rec_query/galaxy.txt
	fi
	if [ -f "./rec_query/photoobjall.txt" ]; then
    	rm ./rec_query/photoobjall.txt
	fi
	if [ -f "./rec_query/photoprimary.txt" ]; then
    	rm ./rec_query/photoprimary.txt
	fi
	if [ -f "./rec_query/star.txt" ]; then
    	rm ./rec_query/star.txt
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
	iquery -q "remove(Galaxy)";
	iquery -q "remove(PhotoObjAll)";
	iquery -q "remove(PhotoPrimary)";
	iquery -q "remove(Star)";
	iquery -q "remove(neighbors)";
}

# 导入Galaxy表
# 参数:
# 数据大小: 10、20、50、100
loadGalaxyFun(){
    sh ./monitor/load_monitor_start.sh
    echo `date`" loading galaxy" >> run.log
    echo -e "\033[32;49;1m [loading galaxy] \033[39;49;0m"
    sleep 2
    echo "load Galaxy time:" > ./rec_load/galaxy.txt
    iquery -aq "set no fetch;load(Galaxy ,'/home/scidb/astronomy_data/"$1"G/Galaxy"$1"_comma.csv',-2, 'CSV');" >> ./rec_load/galaxy.txt
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

# 导入PhotoPrimary表
# 参数:
# 数据大小: 10、20、50、100
loadPhotoPrimaryFun(){
    sh ./monitor/load_monitor_start.sh
    echo `date`" loading photoprimary" >> run.log
    echo -e "\033[32;49;1m [loading photoprimary] \033[39;49;0m"
    sleep 2
    echo "load photoprimary time:" > ./rec_load/photoprimary.txt
    iquery -aq "set no fetch;load(PhotoPrimary ,'/home/scidb/astronomy_data/"$1"G/PhotoPrimary"$1"_comma.csv', -2, 'CSV');" >> ./rec_load/photoprimary.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# 导入Star表
# 参数:
# 数据大小: 10、20、50、100
loadStarFun(){
    sh ./monitor/load_monitor_start.sh
    echo `date`" loading star" >> run.log
    echo -e "\033[32;49;1m [loading star] \033[39;49;0m"
    sleep 2
    echo "load star time:" > ./rec_load/star.txt
    iquery -aq "set no fetch;load(Star ,'/home/scidb/astronomy_data/"$1"G/Star"$1"_comma.csv', -2,'CSV');" >> ./rec_load/star.txt
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
	# 导入Galaxy
	loadGalaxyFun $1

	# 导入PhotoOboAll
	loadPhotoObjAllFun $1

	# 导入PhotoPrimary
	loadPhotoPrimaryFun $1

	# 导入Star
	loadStarFun $1 

	# 导入neighbors
	loadneighborsFun $1
}

# Q1
queryGalaxy_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-1] \033[39;49;0m"
    sleep 2
    echo `date`"Q1" >> run.log 
    echo "Q1" >> ./rec_query/galaxy.txt
    iquery  -f "./sql/galaxy-1.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q1-1
queryGalaxy_1_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-1_1] \033[39;49;0m"
    sleep 2
    echo `date`" Q1-1" >> run.log 
    echo "Q1-1" >> ./rec_query/galaxy.txt
    iquery  -f "./sql/galaxy-1_1.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q2
queryGalaxy_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-2] \033[39;49;0m"
    sleep 2
    echo `date`" Q2" >> run.log
    echo "Q2" >> ./rec_query/galaxy.txt
    iquery -f "./sql/galaxy-2.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q2-1
queryGalaxy_2_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-2_!] \033[39;49;0m"
    sleep 2
    echo `date`" Q2-1" >> run.log
    echo "Q2-1" >> ./rec_query/galaxy.txt
    iquery -f "./sql/galaxy-2_1.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q3
queryGalaxy_3(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-3] \033[39;49;0m"
    sleep 2
    echo `date`" Q3" >> run.log
    echo "Q3" >> ./rec_query/galaxy.txt
    iquery -f "./sql/galaxy-3.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q4
queryGalaxy_4(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-4] \033[39;49;0m"
    sleep 2
    echo `date`" Q4" >> run.log
    echo "Q4" >> ./rec_query/galaxy.txt
    iquery -f "./sql/galaxy-4.sql" >> ./rec_query/galaxy.txt 
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5
queryGalaxy_5(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-5] \033[39;49;0m"
    sleep 2
    echo `date`" Q5" >> run.log
    echo "Q5" >> ./rec_query/galaxy.txt
    #iquery -f "./sql/galaxy-5.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-1
queryGalaxy_5_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-5_1] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-1" >> run.log
    echo "Q5-1" >> ./rec_query/galaxy.txt
    #iquery -f "./sql/galaxy-5_1.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-2
queryGalaxy_5_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-5_2] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-2" >> run.log
    echo "Q5-2" >> ./rec_query/galaxy.txt
    #iquery -f "./sql/galaxy-5_2.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-3
queryGalaxy_5_3(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-5_3] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-3" >> run.log
    echo "Q5-3" >> ./rec_query/galaxy.txt
    iquery -f "./sql/galaxy-5_3.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-4
queryGalaxy_5_4(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-5_4] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-4" >> run.log
    echo "Q5-4" >> ./rec_query/galaxy.txt
    iquery -f "./sql/galaxy-5_4.sql" >> ./rec_query/galaxy.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q5-5
queryGalaxy_5_5(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying galaxy-5_5] \033[39;49;0m"
    sleep 2
    echo `date`" Q5-5" >> run.log
    echo "Q5-5" >> ./rec_query/galaxy.txt
    iquery -f "./sql/galaxy-5_5.sql" >> ./rec_query/galaxy.txt
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
queryPhotoprimary_1(){
    sh ./monitor/monitor_start.sh
    sleep 2
    echo -e "\033[32;49;1m [querying photoprimary-1] \033[39;49;0m"
    echo `date`" Q10" >> run.log
    echo "Q10" >> ./rec_query/photoprimary.txt
    iquery -f "./sql/photoprimary-1.sql" >> ./rec_query/photoprimary.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q11
queryPhotoprimary_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoprimary-2] \033[39;49;0m"
    sleep 2
    echo `date`" Q11" >> run.log
    echo "Q11" >> ./rec_query/photoprimary.txt
    iquery -f "./sql/photoprimary-2.sql" >> ./rec_query/photoprimary.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q11-1
queryPhotoprimary_2_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoprimary-2_1] \033[39;49;0m"
    sleep 2
	echo `date`" Q11-1" >> run.log
    echo "Q11-1" >> ./rec_query/photoprimary.txt
    #iquery -f "./sql/photoprimary-2_1.sql" >> ./rec_query/photoprimary.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q11-2
queryPhotoprimary_2_2(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying photoprimary-2_2] \033[39;49;0m"
    sleep 2
	echo `date`" Q11-2" >> run.log
    echo "Q11-2" >> ./rec_query/photoprimary.txt
    #iquery -f "./sql/photoprimary-2_2.sql" >> ./rec_query/photoprimary.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q12
queryStar_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying star] \033[39;49;0m"
    sleep 2
    echo `date`" Q12" >> run.log
    echo "Q12" >> ./rec_query/star.txt
    iquery -f "./sql/star.sql" >> ./rec_query/star.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# Q12-1
queryStar_1_1(){
    sh ./monitor/monitor_start.sh
    echo -e "\033[32;49;1m [querying star_1_1] \033[39;49;0m"
    sleep 2
    echo `date`" Q12-1" >> run.log
    echo "Q12-1" >> ./rec_query/star.txt
    iquery -f "./sql/star_1.sql" >> ./rec_query/star.txt
    sleep 2
    sh ./monitor/monitor_stop.sh
}

# 表查询
queryTableFun(){
	cleanCacheFun
	queryGalaxy_1

	cleanCacheFun
	queryPhotoobjall_1

	cleanCacheFun
	queryPhotoprimary_1

	cleanCacheFun
	queryStar_1

	cleanCacheFun
	queryGalaxy_2

	cleanCacheFun
	queryPhotoobjall_2

	cleanCacheFun
	queryPhotoprimary_2

	cleanCacheFun
	queryGalaxy_3

	cleanCacheFun
	queryPhotoobjall_3

	cleanCacheFun
	queryGalaxy_4

	cleanCacheFun
	queryPhotoobjall_4

	cleanCacheFun
	queryGalaxy_5

    cleanCacheFun
    queryGalaxy_1_1

    cleanCacheFun
    queryGalaxy_2_1

    cleanCacheFun
    queryGalaxy_5_1

    cleanCacheFun
    queryGalaxy_5_2

    cleanCacheFun
    queryGalaxy_5_3

    cleanCacheFun
    queryGalaxy_5_4

    cleanCacheFun
    queryGalaxy_5_5

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
    queryPhotoprimary_2_1

    cleanCacheFun
    queryPhotoprimary_2_2

    cleanCacheFun
    queryStar_1_1
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

