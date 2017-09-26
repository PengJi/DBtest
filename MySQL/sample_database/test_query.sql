-- 查找薪水涨幅超过15次的员工号emp_no以及其对应的涨幅次数t
select emp_no,count(emp_no) as t 
from salaries group by emp_no having t>15;

-- 查找所有员工的last_name和first_name以及对应的dept_name，
-- 也包括暂时没有分配部门的员工
select e.last_name,e.first_name,d.dept_name 
from 
(employees as e left join dept_emp as de
on e.emp_no=de.emp_no) left join departments as d 
on d.dept_no = de.dept_no;

-- 统计各个部门对应员工涨幅的次数总和，
-- 给出部门编码dept_no、部门名称dept_name以及次数sum
select d.dept_no,d.dept_name,count(s.emp_no) as sum
from departments as d inner join dept_emp as de 
on d.dept_no=de.dept_no
inner join salaries as s on s.emp_no = de.emp_no
group by d.dept_no;

-- 查找所有员工自入职以来的薪水涨幅情况，
-- 给出员工编号emp_noy以及其对应的薪水涨幅growth，
-- 并按照growth进行升序
SELECT sCurrent.emp_no, (sCurrent.salary-sStart.salary) AS growth
FROM 
(SELECT s.emp_no, s.salary 
	FROM employees e inner JOIN salaries s 
	ON e.emp_no = s.emp_no 
	WHERE s.to_date = '9999-01-01') AS sCurrent
INNER JOIN 
(SELECT s.emp_no, s.salary 
	FROM employees e inner JOIN salaries s 
	ON e.emp_no = s.emp_no 
	WHERE s.from_date = e.hire_date) AS sStart
ON sCurrent.emp_no = sStart.emp_no
ORDER BY growth;

-- 对所有员工的薪水按照salary进行按照1-N的排名
-- 对所有员工的当前(to_date='9999-01-01')薪水按照salary进行按照1-N的排名，
-- 相同salary并列且按照emp_no升序排列
SELECT s1.emp_no, s1.salary, COUNT(DISTINCT s2.salary) AS rank
FROM salaries AS s1, salaries AS s2
WHERE s1.to_date = '9999-01-01'  AND s2.to_date = '9999-01-01' AND s1.salary <= s2.salary
GROUP BY s1.emp_no
ORDER BY s1.salary DESC, s1.emp_no ASC;

-- 获取员工其当前的薪水比其manager当前薪水还高的相关信息，当前表示to_date='9999-01-01',
-- 结果第一列给出员工的emp_no，
-- 第二列给出其manager的manager_no，
-- 第三列给出该员工当前的薪水emp_salary,
-- 第四列给该员工对应的manager当前的薪水manager_salary
select t1.emp_no,t2.emp_no as manager_no ,t1.salary as emp_salary,t2.salary as manager_salary
from
(select de.dept_no,de.emp_no,s.salary 
	from dept_emp as de inner join salaries as s 
	on de.emp_no = s.emp_no and s.to_date='9999-01-01'
) as t1 inner join
(select dm.dept_no,dm.emp_no,s.salary 
	from dept_manager as dm inner join salaries as s 
	on dm.emp_no = s.emp_no and s.to_date='9999-01-01'
) as t2 on t1.dept_no=t2.dept_no
and t1.salary>t2.salary;

-- 汇总各个部门当前员工的title类型的分配数目，
-- 结果给出部门编号dept_no、dept_name、
-- 其当前员工所有的title以及该类型title对应的数目count
select d.dept_no,d.dept_name,t.title,count(d.dept_name)
from departments as d inner join dept_emp as de on d.dept_no = de.dept_no
inner join titles as t on t.emp_no = de.emp_no
and de.to_date='9999-01-01' and t.to_date = '9999-01-01'
group by (d.dept_no),t.title;

-- 给出每个员工每年薪水涨幅超过5000的员工编号emp_no、薪水变更开始日期from_date以及薪水涨幅值salary_growth，并按照salary_growth逆序排列。
-- 提示：在sqlite中获取datetime时间对应的年份函数为strftime('%Y', to_date)
select s2.emp_no,s2.from_date,(s2.salary-s1.salary) as salary_growth 
from salaries as s1,salaries as s2
where s1.emp_no=s2.emp_no and salary_growth > 5000 and
(strftime('%Y', s2.to_date) - strftime('%Y', s1.to_date) =1 or
strftime('%Y', s2.from_date) - strftime('%Y', s1.from_date) = 1)
order by salary_growth desc;

--