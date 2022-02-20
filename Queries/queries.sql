SELECT * FROM departments;
SELECT * FROM employees;
SELECT first_name,last_name
FROM employees
WHERE bith_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name,last_name
FROM employees
WHERE (bith_date BETWEEN '1952-01-01' AND '1952-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(first_name)
FROM employees
WHERE (bith_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT first_name,last_name
INTO retirement_info
FROM employees
WHERE (bith_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;
-- Create new table for retiring employees
SELECT emp_no,first_name,last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * 
FROM retirement_info

SELECT d.dept_name,
		dm.emp_no,
		dm.from_date,
		dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no=dm.dept_no;

-- Joining retirement_info and dept_emp tables to see how many left the company
SELECT ri.emp_no,
		ri.first_name,
		ri.last_name,
		de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no;

SELECT ri.emp_no,
		ri.first_name,
		ri.last_name,
		de.to_date
INTO current_emp		
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date=('9999-01-01');

SELECT * 
FROM current_emp;

SELECT COUNT(ce.emp_no) AS "count of employees",de.dept_no
INTO count_current_emp
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

DROP TABLE emp_info
--EMPLOYEE INFORMATION
SELECT e.emp_no,
		e.first_name,
		e.last_name,
		s.salary,
		de.to_date
INTO emp_info		
FROM employees e
INNER JOIN salaries AS s
ON (e.emp_no=s.emp_no)
INNER JOIN dept_emp AS de
ON (e.emp_no=de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');
	 
SELECT *
FROM emp_info
--List of managers per department
SELECT dm.dept_no,
		d.dept_name,
		dm.emp_no,
		ce.first_name,
		ce.last_name,
		dm.from_date,
		dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS d
ON (dm.dept_no=d.dept_no)
INNER JOIN current_emp AS ce
ON (dm.emp_no=ce.emp_no);

SELECT *
FROM manager_info;

--Department Retirees
SELECT ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
INTO dept_info		
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no=d.dept_no);

SELECT * FROM dept_info;

SELECT * FROM dept_info
WHERE dept_name='Sales';

SELECT * FROM dept_info
WHERE dept_name IN ('Sales','Development');