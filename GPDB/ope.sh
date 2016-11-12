:<<doc
功能分解
参数及对应操作：
p --准备工作
q --清空表
d --删除表
c jipeng1008 --清空各节点的缓存
t galaxylj/photoobjall/photoprimarylj/StarLJ/neighbors [a]--创建表
l 10 --导入数据
ll galaxylj 10 --导入某个表
s --查询表
e --结尾工作
doc

. ./funs.sh

# 准备工作
# 参数：
# 操作类型：p
if [ "$1" = "p" ]; then
	createDirFun
	delLoadResFun
	delQueryResFun
fi

# 清空表
# 参数：
# 操作类型：q
if [ "$1" = "q" ]; then
	truncateTableFun
fi

# 删除表
# 参数：
# 操作类型：d
if [ "$1" = "d" ]; then
	dropTableFun
fi

# 清空缓存
# 参数1
# 操作类型：c
# 参数2
# 各节点root的密码
if [ "$1" = "c"  ]; then
	cleanCacheFun $2
fi

# 创建表
# 参数1：
# 操作类型：t
# 参数2：
# 表名：galaxylj/photoobjall/photoprimarylj/StarLJ/neighbors
# 参数3：
# 表的类型：a/ac/ao/aoc/空(默认)
if [ "$1" = "t" ]; then
	createTableFun $2 $3
fi

# 导入数据
# 参数1：
# 操作类型：l
# 参数2
# 数据大小：10、20、50、100
if [ "$1" = "l" ]; then
	loadTable $2
fi

# 导入某个表
# 参数1：
# 操作类型：l
# 参数2
# 表名：galaxylj/photoobjall/photoprimarylj/starlj/neighbors
# 参数3
# 数据大小：10、20、50、100
# 导入某个表
if [ "$1" = "ll" ]; then
	if [ ! -d "./rec_load" ]; then
		mkdir ./rec_load
	fi  
	if [ "$2" = "galaxylj" ]; then
        loadGalaxyljFun $3
    elif [ "$2" = "photoobjall" ]; then
        loadPhotoobjallFun $3
    elif [ "$2" = "photoprimarylj" ]; then
        loadPhotoprimaryljFun $3
    elif [ "$2" = "starlj" ]; then
        loadStarljFun $3
    elif [ "$2" = "neighbors" ]; then
        loadneighborsFun $3
    else
        echo -e "\033[31;49;1m [table not exists] \033[39;49;0m"
    fi 
fi

# 查询所有表
# 参数
# 操作类型：s
if [ "$1" = "s" ]; then
	queryTableFun
fi

# 查询单个表
# 参数1：
# 操作类型：sg
# 参数2：
# 查询：Q1/Q2/Q3/Q4/Q5/Q6/Q7/Q8/Q9/Q10/Q11/Q12
if [ "$1" = "sg"  ]; then
	if [ ! -d "./rec_query" ]; then
		mkdir ./rec_query
	fi
	case $2 in
		"Q1") queryGalaxylj_1 
		;;
		"Q1-1") queryGalaxylj_1_1
		;;
		"Q2") queryGalaxylj_2
		;;
		"Q2-1") queryGalaxylj_2_1
		;;
		"Q3") queryGalaxylj_3
		;;
		"Q4") queryGalaxylj_4
		;;
		"Q5") queryGalaxylj_5
		;;
		"Q5-1") queryGalaxylj_5_1
		;;
		"Q5-2") queryGalaxylj_5_2
		;;
		"Q5-3") queryGalaxylj_5_3
		;;
		"Q5-4") queryGalaxylj_5_4
		;;
		"Q5-5") queryGalaxylj_5_5
		;;
		"Q6") queryPhotoobjall_1
		;;
		"Q6-1") queryPhotoobjall_1_1
		;;
		"Q7") queryPhotoobjall_2
		;;
		"Q7-1") queryPhotoobjall_2_1 
		;;
		"Q8") queryPhotoobjall_3  
		;;
		"Q8-1") queryPhotoobjall_3_1  
		;;
		"Q9") queryPhotoobjall_4 
		;;
		"Q9-1") queryPhotoobjall_4_1
		;;
		"Q9-2") queryPhotoobjall_4_2
		;;
		"Q10") queryPhotoprimarylj_1
		;;
		"Q11") queryPhotoprimarylj_2
		;;
		"Q11-1") queryPhotoprimarylj_2_1
		;;
		"Q11-2") queryPhotoprimarylj_2_2
		;;
		"Q12") queryStarlj_1
		;;
		"Q12-1") queryStarlj_1_1
		;;
		*) echo -e "\033[31;49;1m [query not exists] \033[39;49;0m"
		;;
	esac
fi

# 导入和查询数据
# 参数
# 操作类型：ls
if [ "$1" = "ls" ]; then
	echo "load and query table"
fi

# 结尾工作
# 参数：
# 操作类型：e
if [ "$1" = "e" ]; then
	# 清空表
	truncateTableFun
    # 删除表
    delTable
    # 清空缓存
    cleanCacheFun
fi
