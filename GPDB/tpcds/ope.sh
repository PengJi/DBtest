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
conv -f latin1 -t UTF-8 customer.dat -o customer1.dat   

# 空格转为comma
#windows
.\sed.exe -e "s/\s\+/,/g" I:\comma\PhotoObiAll100comma.csv > PhotoObiAll100comma_new.csv
# linux
sed -e "s/\s\+/,/g" test > test1
sed 's/  */,/g' test> test1

# 删除每行最后的逗号
sed 's/,.$//' txt > test
