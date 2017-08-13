:<<doc

doc

. ./preproccess.sh

if [ "$1" = "delend" ]; then
	delEnd
fi

if [ "$1" = "loaddata" ]; then
	loadData
fi
