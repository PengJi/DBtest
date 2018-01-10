:<<doc
delend   删除原始行尾，生成要导入的文件
loaddata 导入数据
doc

. ./preproccess.sh

if [ "$1" = "delend" ]
then
	delEnd
elif [ "$1" = "loaddata" ]
then
	loadData
else
	echo -e "\033[31;49;1m [wrong parameters] \033[39;49;0m"
fi
