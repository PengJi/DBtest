:<<doc
程序入口
doc

. ./funs.sh

echo -e "\033[35;49;1m [program start] \033[39;49;0m"
echo "************************************program start**************************************" >> run.log

# 普通表分别执行10次
truncateTableFun
dropTableFun
createTableFun galaxy
createTableFun photoobjall 
createTableFun photoprimary
createTableFun Star
createTableFun neighbors
mainFun

# appendonly表分别执行10次
truncateTableFun
dropTableFun
createTableFun galaxy a
createTableFun photoobjall a
createTableFun photoprimary a
createTableFun Star a
createTableFun neighbors
mainFun a

# 压缩表分别执行10次
truncateTableFun
dropTableFun
createTableFun galaxy ac
createTableFun photoobjall ac
createTableFun photoprimary ac
createTableFun Star ac
createTableFun neighbors
mainFun ac

# 列存储表分别执行10次
truncateTableFun
dropTableFun
createTableFun galaxy ao
createTableFun photoobjall ao 
createTableFun photoprimary ao
createTableFun Star ao
createTableFun neighbors
mainFun ao

# 列存储压缩表分别执行10次
truncateTableFun
dropTableFun
createTableFun galaxy aoc
createTableFun photoobjall aoc
createTableFun photoprimary aoc
createTableFun Star aoc
createTableFun neighbors
mainFun aoc

# 清理数据库和文件
cleanCacheFun
truncateTableFun
delQueryResFun
dropTableFun

echo -e "\033[35;49;1m [program end] \033[39;49;0m"
echo "************************************program end**************************************" >> run.log
