--DROP TABLE
DROP TABLE IF EXISTS retirement_titles;
DROP TABLE IF EXISTS unique_titles;
DROP TABLE IF EXISTS retiring_titles;
DROP TABLE IF EXISTS mentorship_eligibility;
DROP TABLE IF EXISTS mentors_title_count_avg_salary;
DROP TABLE IF EXISTS mentors_dept_and_salary;
DROP TABLE IF EXISTS total_mentors_in_each_dept;
DROP TABLE IF EXISTS manager_each_dept;
DROP TABLE IF EXISTS mentors_manager_info;
--
SELECT  e.emp_no, 
		e.first_name, 
		e.last_name,
		t.title, 
		t.from_date, 
		t.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
ON e.emp_no=t.emp_no
WHERE e.birth_date BETWEEN '1951-01-01' AND '1955-12-31'
ORDER BY e.emp_no;
--
SELECT * FROM retirement_titles;
--
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no),
					emp_no,
					first_name,
					last_name,
					title
INTO unique_titles
FROM retirement_titles
WHERE to_date='9999-01-01'
ORDER BY emp_no, to_date DESC;
--
SELECT * FROM unique_titles;
--
-- Select employees by their most recent job title who are about to retire.
SELECT 	COUNT(title) AS count_by_title,
		title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count_by_title DESC;
--
SELECT * FROM retiring_titles;
--
--Employees eligible for mentorship
SELECT DISTINCT ON (e.emp_no)
					e.emp_no,
					e.first_name,
					e.last_name,
					e.birth_date,
					de.from_date,
					de.to_date,
					t.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no=de.emp_no
INNER JOIN titles AS t
ON e.emp_no=t.emp_no
WHERE (de.to_date='9999-01-01') AND 
	(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'	)
ORDER BY e.emp_no,t.to_date DESC;
--
SELECT * FROM mentorship_eligibility;
--
--ADDTIONAL TABLES AND QUERIES for MENTORSHIP PROGRAM:

--Count of Titles of eligible employees and average salary for each title in Mentorship Program
SELECT 	COUNT(me.title) AS titles_count,
		me.title, 
		ROUND(AVG(salary),2) AS average_salary
INTO mentors_title_count_avg_salary		
FROM mentorship_eligibility AS me
INNER JOIN salaries AS s
ON me.emp_no=s.emp_no
GROUP BY me.title
ORDER BY titles_count;
--
SELECT * FROM mentors_title_count_avg_salary;
--
--Merge Salaries and Department tables to get the salary and department info. of the Mentorship Program Eligibile Employees.
SELECT 	me.emp_no,
		d.dept_no,
		me.first_name,
		me.last_name,
		me.title,
		d.dept_name,
		s.salary
INTO mentors_dept_and_salary
FROM mentorship_eligibility AS me
INNER JOIN dept_emp AS de
ON me.emp_no=de.emp_no
INNER JOIN departments AS d
ON de.dept_no=d.dept_no
INNER JOIN salaries AS s
ON me.emp_no=s.emp_no
WHERE de.to_date='9999-01-01';
---
SELECT * FROM mentors_dept_and_salary;
--
--Total employees from each department that are eligible for mentorship program
SELECT COUNT(dept_name),
			dept_name
INTO total_mentors_in_each_dept			
FROM mentors_dept_and_salary
GROUP BY dept_name;
--
SELECT * FROM total_mentors_in_each_dept;
--
--Manager information by Department:
--
SELECT c.first_name,c.last_name,d.emp_no,d.dept_no
INTO manager_each_dept
FROM dept_manager AS d
INNER JOIN employees AS c
ON d.emp_no=c.emp_no
WHERE d.to_date='9999-01-01';
--
SELECT * FROM manager_each_dept;

--Employee's Manager info eligible for Mentorship Program
SELECT  m.emp_no,
		m.first_name,
		m.last_name,
		m.dept_name,
		n.first_name AS manager_FN,
		n.last_name AS manager_LN
INTO mentors_manager_info		
FROM mentors_dept_and_salary AS m 
INNER JOIN manager_each_dept AS n 
ON m.dept_no=n.dept_no;
--
SELECT * FROM mentors_manager_info;
--
