:<<doc
辅助函数:
createDirFun --创建存放结果的目录
createTableFun galaxylj a --创建表
mainFun a --执行导入和查询
cleanCacheFun --清空缓存
truncateTableFun --清空表
dropTableFun --删除表
delLoadResFun --删除旧的导入结果文件
delQueryResFun --删除旧的查询结果文件
loadTable 10 --导入表
getTabeSizeFun --得到导入之后表的大小
colResFun --汇总结果
doc

# 清空集群中节点的缓存
# 参数:
# 各节点root的密码，存在默认密码
cleanCacheFun(){
	if [ -n "${1}" ]; then
		passwd="$1"
	else
		passwd="jipeng1008"
	fi
	echo `date`" start clear cache" >> run.log
	echo -e "\033[32;49;1m [clear cache] \033[39;49;0m"
	echo -e "\033[33;49;1m [input root's password] \033[39;49;0m"
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
echo `date`" clear node${k} cache" >> run.log
expect << exp
spawn ssh root@node${k}
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

# 创建表
# 参数1：
# 表名：galaxylj/photoobjall/photoprimarylj/StarLJ/neighbors
# 参数2(可选)：
# 表的类型：a/ac/ao/aoc/空(默认)
createTableFun(){
	if [ $1 == "neighbors" ]
	then
		echo `date`" create $1" >> run.log
		psql -d astronomy -f "./sql/"$1".sql"
		return
	fi

	if  [ -n "$2" ] ;then
    	if [ $2 == "a" ]
	    then
    	    echo `date`" create "$1"_a" >> run.log
			psql -d astronomy -f "./sql/"$1"_a.sql"
	    elif [ $2 == "ac" ]
    	then
        	echo `date`" create "$1"_ac" >> run.log
			psql -d astronomy -f "./sql/"$1"_ac.sql"
	    elif [ $2 == "ao" ]
    	then
        	echo `date`" create "$1"_ao" >> run.log
			psql -d astronomy -f "./sql/"$1"_ao.sql"
		elif [ $2 == "aoc" ]
		then
			echo `date`" create "$1"_aoc" >> run.log
			psql -d astronomy -f "./sql/"$1"_aoc.sql"
	    fi  
	else
        echo `date`" create $1" >> run.log
		psql -d astronomy -f "./sql/"$1".sql"
	fi
}

# 清空表
# galaxylj/neighbors/photoobjall/photoprimarylj/starlj为5个表
truncateTableFun(){
	echo `date`" start truncate tables" >> run.log
	echo -e "\033[32;49;1m [truncate tables] \033[39;49;0m"
	psql -d astronomy -c "truncate galaxylj;truncate neighbors;truncate photoobjall;truncate photoprimarylj;truncate starlj;" >> run.log
	echo `date`" end truncate tables" >> run.log
}

# 删除表
dropTableFun(){
	echo `date`" start drop tables" >> run.log
    echo -e "\033[32;49;1m [drop tables] \033[39;49;0m"
    psql -d astronomy -c "drop table galaxylj;drop table neighbors;drop table photoobjall;drop table photoprimarylj;drop table starlj;" >> run.log
    echo `date`" end drop tables" >> run.log
}

# 创建目录
# rec_load 存放导入结果
# rec_query 存放查询结果
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

# 删除旧的导入结果文件
# 参数：
# 各节点的登陆用户名，默认为gpadmin
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

	if [ -n "${1}" ]; then
    	user="$1"
	else
    	user="gpadmin"
	fi

	for k in $(seq 1 6)
	do
ssh ${user}@node${k} << eof
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

    if [ -n "${1}" ]; then
        user="$1"
    else
        user="gpadmin"
    fi 

for k in $(seq 1 6)
do
ssh ${user}@node${k} << eof
    if [ -f "/tmp/monitor${k}.txt" ]; then
        rm /tmp/monitor${k}.txt
    fi
eof
done
}

# 执行导入和查询
# 参数:
# 表的类型：a/ac/ao/aoc/空
mainFun(){
	if [ -n "$1" ]
	then
		mkdir ./1G_$1
		mkdir ./10G_$1
		mkdir ./20G_$1
		mkdir ./50G_$1
	
		# 导入和查询1G数据
		for k in $(seq 1 5 )
		do
    		./run.sh 1
	    	mv ./rec_load ./rec_load-${k}
	    	mv ./rec_query ./rec_query-${k}
		    mv ./rec_load-${k} ./1G_$1
	    	mv ./rec_query-${k} ./1G_$1
		done
		# 导入和查询10G数据
		for k in $(seq 1 5 )
		do
    		./run.sh 10
	    	mv ./rec_load ./rec_load-${k}
	    	mv ./rec_query ./rec_query-${k}
		    mv ./rec_load-${k} ./10G_$1
	    	mv ./rec_query-${k} ./10G_$1
		done

		# 导入和查询20G数据
		for k in $(seq 1 5 )
		do
	    	./run.sh 20
		    mv ./rec_load ./rec_load-${k}
	    	mv ./rec_query ./rec_query-${k}
		    mv ./rec_load-${k} ./20G_$1
		    mv ./rec_query-${k} ./20G_$1
		done

		# 导入和查询50G数据
		for k in $(seq 1 5 )
		do
	    	./run.sh 50
		    mv ./rec_load ./rec_load-${k}
		    mv ./rec_query ./rec_query-${k}
		    mv ./rec_load-${k} ./50G_$1
		    mv ./rec_query-${k} ./50G_$1
		done
	else
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
	fi
}

# 导入galaxylj表
# 参数:
# 数据大小：10、20、50、100
loadGalaxyljFun(){
	sh ./monitor/load_monitor_start.sh
	echo `date`" loading galaxylj" >> run.log
	echo -e "\033[32;49;1m [loading galaxylj] \033[39;49;0m"
	sleep 2
	gpload -f /home/gpadmin/astronomy_data/"$1"G/galaxylj"$1"_comma.yaml > ./rec_load/galaxylj.txt
	sleep 2
	sh ./monitor/monitor_stop.sh
}

# 导入photoobjall表
# 参数:
# 数据大小：10、20、50、100
loadPhotoobjallFun(){
	sh ./monitor/load_monitor_start.sh
	echo `date`" loading photoobjall" >> run.log
	echo -e "\033[32;49;1m [loading photoobjall] \033[39;49;0m"
	sleep 2
	gpload -f /home/gpadmin/astronomy_data/"$1"G/photoobjall"$1"_comma.yaml > ./rec_load/photoobjall.txt
	sleep 2
	sh ./monitor/monitor_stop.sh
}

# 导入photoprimarylj表
# 参数:
# 数据大小：10、20、50、100
loadPhotoprimaryljFun(){
	sh ./monitor/load_monitor_start.sh
	echo `date`" loading photoprimarylj" >> run.log
	echo -e "\033[32;49;1m [loading photoprimarylj] \033[39;49;0m"
	sleep 2
	gpload -f /home/gpadmin/astronomy_data/"$1"G/photoprimarylj"$1"_comma.yaml > ./rec_load/photoprimarylj.txt
	sleep 2
	sh ./monitor/monitor_stop.sh
}

# 导入starlj表
# 参数:
# 数据大小：10、20、50、100
loadStarljFun(){
	sh ./monitor/load_monitor_start.sh
	echo `date`" loading starlj" >> run.log
	echo -e "\033[32;49;1m [loading starlj] \033[39;49;0m"
	sleep 2
	gpload -f /home/gpadmin/astronomy_data/"$1"G/starlj"$1"_comma.yaml > ./rec_load/starlj.txt
	sleep 2
	sh ./monitor/monitor_stop.sh
}

# 导入neighbors表
# 参数:
# 数据大小：10、20、50、100
loadneighborsFun(){
	sh ./monitor/load_monitor_start.sh
	echo `date`" loading neighbors" >> run.log
	echo -e "\033[32;49;1m [loading neighbors] \033[39;49;0m"
	sleep 2
	gpload -f /home/gpadmin/astronomy_data/"$1"G/neighbors"$1"_comma.yaml > ./rec_load/neighbors.txt
	sleep 2
	sh ./monitor/monitor_stop.sh
}

# 导入所有表
# 参数:
# 数据大小：1、10、20、50、100
loadTable(){
    # 导入galaxylj
	loadGalaxyljFun $1

    # 导入photoobjall
	loadPhotoobjallFun $1

    # 导入photoprimarylj
	loadPhotoprimaryljFun $1

    # 导入starlj
	loadStarljFun $1

    # 导入neighbors
	loadneighborsFun $1
}

# 得到导入后表的大小
getTabeSizeFun(){
	echo `date`" get table size" >> run.log
	echo -e "\033[32;49;1m [get table size] \033[39;49;0m"
	echo "galaxylj size" >> ./rec_load/table_size.txt
	psql -d astronomy -c "select pg_size_pretty(pg_total_relation_size('galaxylj'));" >> ./rec_load/table_size.txt
	echo "photoobjall size" >> ./rec_load/table_size.txt
	psql -d astronomy -c "select pg_size_pretty(pg_total_relation_size('photoobjall'));" >> ./rec_load/table_size.txt
	echo "photoprimarylj siez" >> ./rec_load/table_size.txt
	psql -d astronomy -c "select pg_size_pretty(pg_total_relation_size('photoprimarylj'));" >> ./rec_load/table_size.txt
	echo "starlj size" >> ./rec_load/table_size.txt 
	psql -d astronomy -c "select pg_size_pretty(pg_total_relation_size('starlj'));" >> ./rec_load/table_size.txt
	echo "neighbors size" >> ./rec_load/table_size.txt
	psql -d astronomy -c "select pg_size_pretty(pg_total_relation_size('neighbors'));" >> ./rec_load/table_size.txt
}

# Q1
queryGalaxylj_1(){
	sh ./monitor/monitor_start.sh
	echo -e "\033[32;49;1m [querying galaxylj-1] \033[39;49;0m"
	sleep 2
	echo `date`" Q1" >> run.log
	echo "Q1" >> ./rec_query/galaxylj.txt
	psql -d astronomy -f "./sql/galaxylj-1.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-1_1.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-2.sql" >> ./rec_query/galaxylj.txt
	sleep 2 
	sh ./monitor/monitor_stop.sh
}

# Q2-1
queryGalaxylj_2_1(){
	sh ./monitor/monitor_start.sh
	echo -e "\033[32;49;1m [querying galaxylj-2_1] \033[39;49;0m"
	sleep 2
	echo `date`" Q2-1" >> run.log
	echo "Q2-1" >> ./rec_query/galaxylj.txt
	psql -d astronomy -f "./sql/galaxylj-2_1.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-3.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-4.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-5.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-5_1.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-5_2.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-5_3.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-5_4.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/galaxylj-5_5.sql" >> ./rec_query/galaxylj.txt
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
	psql -d astronomy -f "./sql/photoobjall-1.sql" >> ./rec_query/photoobjall.txt
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
	psql -d astronomy -f "./sql/photoobjall-1_1.sql" >> ./rec_query/photoobjall.txt
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
	psql -d astronomy -f "./sql/photoobjall-2.sql" >> ./rec_query/photoobjall.txt
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
	psql -d astronomy -f "./sql/photoobjall-2_1.sql" >> ./rec_query/photoobjall.txt
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
	psql -d astronomy -f "./sql/photoobjall-3.sql" >> ./rec_query/photoobjall.txt
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
	psql -d astronomy -f "./sql/photoobjall-3_1.sql" >> ./rec_query/photoobjall.txt
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
	psql -d astronomy -f "./sql/photoobjall-4.sql" >> ./rec_query/photoobjall.txt
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
	psql -d astronomy -f "./sql/photoobjall-4_1.sql" >> ./rec_query/photoobjall.txt
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
	psql -d astronomy -f "./sql/photoobjall-4_2.sql" >> ./rec_query/photoobjall.txt
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
	psql -d astronomy -f "./sql/photoprimarylj-1.sql" >> ./rec_query/photoprimarylj.txt
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
	psql -d astronomy -f "./sql/photoprimarylj-2.sql" >> ./rec_query/photoprimarylj.txt
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
	psql -d astronomy -f "./sql/photoprimarylj-2_1.sql" >> ./rec_query/photoprimarylj.txt
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
	psql -d astronomy -f "./sql/photoprimarylj-2_2.sql" >> ./rec_query/photoprimarylj.txt
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
	psql -d astronomy -f "./sql/starlj.sql" >> ./rec_query/starlj.txt
	sleep 2 
	sh ./monitor/monitor_stop.sh
}

# Q12-1
queryStarlj_1_1(){
	sh ./monitor/monitor_start.sh
	echo -e "\033[32;49;1m [querying starlj_1] \033[39;49;0m"
	sleep 2
	echo `date`" Q12-1" >> run.log
	echo "Q12-1" >> ./rec_query/starlj.txt
	psql -d astronomy -f "./sql/starlj_1.sql" >> ./rec_query/starlj.txt
	sleep 2 
	sh ./monitor/monitor_stop.sh
}

# 查询表
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
# 参数：
# 各节点的登陆用户，默认为：gpadmin
colResFun(){
    echo `date`" scp files" >> run.log
    echo -e "\033[32;49;1m [scp files] \033[39;49;0m"
    if [ -n "${1}" ]; then
        user="$1"
    else
        user="gpadmin"
    fi 
for k in $(seq 1 6)
do
echo `date`" worker${k} scp" >> run.log
echo -e "\033[33;49;1m [node${k} scp] \033[39;49;0m"
ssh ${user}@node${k} << eof
if [ -f "/tmp/monitor${k}.txt" ]; then
    scp -o StrictHostKeyChecking=no /tmp/monitor${k}.txt ${user}@JPDB2:/tmp 
fi
eof
done
    mv /tmp/monitor.txt /tmp/monitor1.txt /tmp/monitor2.txt /tmp/monitor3.txt /tmp/monitor4.txt /tmp/monitor5.txt /tmp/monitor6.txt $1
}

