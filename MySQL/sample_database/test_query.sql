-- 查找薪水涨幅超过15次的员工号emp_no以及其对应的涨幅次数t
select emp_no,count(emp_no) as t from salaries group by emp_no having t>15