# 去掉每行最后一个字符
sed -i 's/.$//' customer.dat

# 删除以 | 结尾的行
sed -i '/|$/d' customer.dat

# 删除包含 || 的行
sed -i '/||/d' customer.dat

# 查看文件编码
:set fileencoding

# 去掉第一行
sed -i "1d" xxx.csv-f 

# 转换编码
iconv -f latin1 -t UTF-8 customer.dat -o customer1.dat   

# 空格转为comma
#windows
.\sed.exe -e "s/\s\+/,/g" I:\comma\PhotoObiAll100comma.csv > PhotoObiAll100comma_new.csv
# linux
sed -e "s/\s\+/,/g" test > test1
sed 's/  */,/g' test> test1

# 删除每行最后的逗号
sed 's/,.$//' txt > test

# 修改权限
echo "host    all all 0.0.0.0/0   trust" >> /home/gpdba/gpdata/master/gpseg-1/pg_hba.conf

# greenplum脚本测试网络性能
gpcheckperf -f gpconfigs/seg_hosts_5 -d /home/gpdba/gpdata1 -d /home/gpdba/gpdata2 -r dsM --netperf

# 监控网络和磁盘
collectl -sDN --dskfilt ^dm --netfilt ens -oT -P -f test

# 关闭collectl程序
pgrep collectl | xargs kill -9

# 压缩文件
zip -r isolation.zip isolation/*

# nohup使用，输出重定向
nohup [command] >> myout.file 2>&1 &
