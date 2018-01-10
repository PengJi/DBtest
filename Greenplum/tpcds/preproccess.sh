:<<doc
数据预处理
doc

# 去掉每行末尾的 | 
delEnd(){
	source_path="/home/gpdba/tpcds_data/rawdata"
	des_path="/home/gpdba/tpcds_data/csv"
	for i in `ls $source_path`
	do
		echo -e "\033[32;49;1m [$source_path/$i] \033[39;49;0m"
		sed 's/|$//' $source_path/$i > $des_path/${i/dat/csv}
	done;
}

# 导入文件
loadData(){
	yaml_path="/home/gpdba/DBtest/GPDB/tpcds/yaml"
	for i in `ls $yaml_path`
	do
		echo -e "\033[32;49;1m [load $i] \033[39;49;0m"
		gpload -f $yaml_path/$i
	done;
}
