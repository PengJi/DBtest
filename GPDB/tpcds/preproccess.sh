# 去掉每行末尾的 | 
source_path="/home/gpdba/tpcds_data/testdata"
des_path="/home/gpdba/tpcds_data/csv"
for i in `ls /home/gpdba/tpcds_data/testdata`
do
	sed 's/|$//' $source_path/$i > $des_path/${i/dat/csv}
   	echo $source_path/$i
done;
