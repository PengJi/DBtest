# 去掉每行末尾的 | 
data_path="/home/gpdba/tpcds_data/testdata"
for i in `ls /home/gpdba/tpcds_data/testdata`
do
	sed 's/|$//' $data_path/$i > ${i/dat/csv}
   	echo $data_path/$i
done;
