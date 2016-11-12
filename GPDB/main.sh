:<<doc
程序入口
doc

. ./funs.sh

echo -e "\033[35;49;1m [program start] \033[39;49;0m"
echo "************************************program start**************************************" >> run.log

truncateTableFun
dropTableFun

# 普通表分别执行10次
createTableFun galaxy
createTableFun photoobjall 
createTableFun photoprimary
createTableFun Star
createTableFun neighbors

mainFun

truncateTableFun
dropTableFun

# appendonly表分别执行10次
createTableFun galaxy a
createTableFun photoobjall a
createTableFun photoprimary a
createTableFun Star a
createTableFun neighbors

mainFun a

truncateTableFun
dropTableFun

# 压缩表分别执行10次
createTableFun galaxy ac
createTableFun photoobjall ac
createTableFun photoprimary ac
createTableFun Star ac
createTableFun neighbors

mainFun ac

truncateTableFun
dropTableFun

# 列存储表分别执行10次
createTableFun galaxy ao
createTableFun photoobjall ao 
createTableFun photoprimary ao
createTableFun Star ao
createTableFun neighbors

mainFun ao

truncateTableFun
dropTableFun

# 列存储压缩表分别执行10次
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
