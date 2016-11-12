# stop collectl
echo -e "\033[31;49;1m [JPDB1 stop] \033[39;49;0m"
pgrep collectl | xargs kill -9  

for k in $(seq 1 6)
do
echo -e "\033[31;49;1m [worker${k} stop] \033[39;49;0m"
ssh scidb@worker${k} << eof
  pgrep collectl | xargs kill -9
eof
done

echo -e "\033[32;49;1m [monitor stopped] \033[39;49;0m"

