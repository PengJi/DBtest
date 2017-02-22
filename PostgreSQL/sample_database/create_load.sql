database="testDB"

echo -e "\033[32;49;1m [create table] \033[39;49;0m"
psql -d ${database} -f employees.sql

echo -e "\033[32;49;1m [load_departments] \033[39;49;0m"
psql -d ${database} -f load_departments.dump
echo -e "\033[32;49;1m [load_employees] \033[39;49;0m"
psql -d ${database} -f load_employees.dump
echo -e "\033[32;49;1m [load_dept_emp] \033[39;49;0m"
psql -d ${database} -f load_dept_emp.dump
echo -e "\033[32;49;1m [load_dept_manager] \033[39;49;0m"
psql -d ${database} -f load_dept_manager.dump
echo -e "\033[32;49;1m [load_titles] \033[39;49;0m"
psql -d ${database} -f load_titles.dump
echo -e "\033[32;49;1m [load_salaries] \033[39;49;0m"
psql -d ${database} -f load_salaries.dump

