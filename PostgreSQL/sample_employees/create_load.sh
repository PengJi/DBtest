#数据库名
database="testDB"
#dump数据文件路径
file_path="/home/postgres/packages/employees_db"

#预处理文件
sed -i 's/`departments`/departments/g' ${file_path}/load_departments.dump
sed -i 's/`dept_emp`/dept_emp/g' ${file_path}/load_dept_emp.dump
sed -i 's/`dept_manager`/dept_manager/g' ${file_path}/load_dept_manager.dump
sed -i 's/`employees`/employees/g' ${file_path}/load_employees.dump
sed -i 's/`salaries`/salaries/g' ${file_path}/load_salaries.dump
sed -i 's/`titles`/titles/g' ${file_path}/load_titles.dump

#创建表并导入数据
echo -e "\033[32;49;1m [create table] \033[39;49;0m"
psql -d ${database} -f employees.sql

echo -e "\033[32;49;1m [load_departments] \033[39;49;0m"
psql -d ${database} -f ${file_path}/load_departments.dump
echo -e "\033[32;49;1m [load_employees] \033[39;49;0m"
psql -d ${database} -f ${file_path}/load_employees.dump
echo -e "\033[32;49;1m [load_dept_emp] \033[39;49;0m"
psql -d ${database} -f ${file_path}/load_dept_emp.dump
echo -e "\033[32;49;1m [load_dept_manager] \033[39;49;0m"
psql -d ${database} -f ${file_path}/load_dept_manager.dump
echo -e "\033[32;49;1m [load_titles] \033[39;49;0m"
psql -d ${database} -f ${file_path}/load_titles.dump
echo -e "\033[32;49;1m [load_salaries] \033[39;49;0m"
psql -d ${database} -f ${file_path}/load_salaries.dump

