:<<doc
程序入口
doc

. ./funs.sh

echo -e "\033[35;49;1m [program start] \033[39;49;0m"
echo "************************************program start**************************************" >> run.log

truncateTableFun
dropTableFun

# 普通表分别执行10次
createTableFun galaxylj
createTableFun photoobjall 
createTableFun photoprimarylj
createTableFun StarLJ
createTableFun neighbors

mainFun

truncateTableFun
dropTableFun

# appendonly表分别执行10次
createTableFun galaxylj a
createTableFun photoobjall a
createTableFun photoprimarylj a
createTableFun StarLJ a
createTableFun neighbors

mainFun a

truncateTableFun
dropTableFun

# 压缩表分别执行10次
createTableFun galaxylj ac
createTableFun photoobjall ac
createTableFun photoprimarylj ac
createTableFun StarLJ ac
createTableFun neighbors

mainFun ac

truncateTableFun
dropTableFun

# 列存储表分别执行10次
createTableFun galaxylj ao
createTableFun photoobjall ao 
createTableFun photoprimarylj ao
createTableFun StarLJ ao
createTableFun neighbors

mainFun ao

truncateTableFun
dropTableFun

# 列存储压缩表分别执行10次
createTableFun galaxylj aoc
createTableFun photoobjall aoc
createTableFun photoprimarylj aoc
createTableFun StarLJ aoc
createTableFun neighbors

mainFun aoc

# 清理数据库和文件
cleanCacheFun
truncateTableFun
delQueryResFun
dropTableFun

echo -e "\033[35;49;1m [program end] \033[39;49;0m"
echo "************************************program end**************************************" >> run.log
