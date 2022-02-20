# Pewlett-Hackard-Analysis
SQL
**MODULE 7**

**EMPLOYEES DATABASE ANALYSIS**

**Overview of the analysis:** In this project we are helping Booby to identify the employees who are reaching the retirement age by Title and who are eligible for Mentorship Program using following tables:

- a Retirement Titles table that holds all the titles of employees who were born between January 1, 1952 and December 31, 1955
- Using DISTINCT ON function tried to get the most recent title of each employee as employees have multiple titles and created the unique\_titles table.
- Then using the COUNT() function we created the retiring\_titles table to get the number of retirement-age employees by most recent job title.
- At last we created a table to identify the employees who are eligible for the mentorship program.

**Results:**

1. There are 72458 employees that are ready to retire.
 [!Retirees by there Title](https://github.com/AditiOracle/Pewlett-Hackard-Analysis/blob/main/Resources_image/unique_titles_output.PNG)
2. We have an outlier here. There are only 2 Managers that are going to retire.
5. A big Silver Tsunami is actually coming in Senior Engineer and Senior Staff titles where 25916 and 24926 employees are retiring respectively.
6. We have total 1549 employees that are eligible for Mentorship Program.

**Summary:**

- _ **How many roles will need to be filled as the &quot;silver tsunami&quot; begins to make an impact?** _

![Shape1](RackMultipart20220220-4-72k9di_html_5b9712608cef6256.gif)

SELECT COUNT(title) AS count\_by\_title,

title

INTO retiring\_titles

FROM unique\_titles

GROUP BY title

ORDER BY count\_by\_title DESC;

| 25916 | Senior Engineer |
| --- | --- |
| 24926 | Senior Staff |
| 9285 | Engineer |
| 7636 | Staff |
| 3603 | Technique Leader |
| 1090 | Assistant Engineer |
| 2 | Manager |

- _ **Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?** _

If I go by the employees Titles -\&gt; There are not enough employees from Title – Manager. We have only 2 Managers who are qualify for retirement but they are not qualifying for Mentorship program. (See the table in above question.)

- And If I go by the departments: I think we have enough employees from each department to go for Mentorship Program. For this I have created a new Table - mentors\_dept\_and\_salary to get the departments for the employees eligible for the Mentorship Program:

![Shape2](RackMultipart20220220-4-72k9di_html_ced65d3df79708bf.gif)

SELECT me.emp\_no,me.first\_name,me.last\_name,me.title,d.dept\_name,s.salary

INTO mentors\_dept\_and\_salary

FROM mentorship\_eligibility as me

INNER JOIN dept\_emp as de

ON me.emp\_no=de.emp\_no

INNER JOIN departments as d

ON de.dept\_no=d.dept\_no

INNER JOIN salaries as s

ON me.emp\_no=s.emp\_no

WHERE de.to\_date=&#39;9999-01-01&#39;;

And then used this Table to group by the dept\_name to see how many employees we have from each department those are eligible for Mentorship Program.

![Shape3](RackMultipart20220220-4-72k9di_html_7875820ef01635b8.gif)

SELECT COUNT(dept\_name),dept\_name

FROM mentors\_dept\_and\_salary

GROUP BY dept\_name

**ADDITIONAL NEW QUERIES FOR MENTORSHIP PROGRAM:**

1. Count of Titles of eligible employees and average salary for each title in Mentorship Program:

![Shape4](RackMultipart20220220-4-72k9di_html_5d1ac8ae9971080f.gif)

SELECT COUNT(me.title) AS titles\_count,

me.title,

ROUND(AVG(salary),2) AS average\_salary

INTO mentors\_title\_count\_avg\_salary

FROM mentorship\_eligibility AS me

INNER JOIN salaries AS s

ON me.emp\_no=s.emp\_no

GROUP BY me.title

ORDER BY titles\_count;

1. Merge Salaries and Department tables to get the salary and department info. of the Mentorship Program Eligible Employees.

![Shape5](RackMultipart20220220-4-72k9di_html_50caf8a9750e907f.gif)

SELECT me.emp\_no,

d.dept\_no,

me.first\_name,

me.last\_name,

me.title,

d.dept\_name,

s.salary

INTO mentors\_dept\_and\_salary

FROM mentorship\_eligibility AS me

INNER JOIN dept\_emp AS de

ON me.emp\_no=de.emp\_no

INNER JOIN departments AS d

ON de.dept\_no=d.dept\_no

INNER JOIN salaries AS s

ON me.emp\_no=s.emp\_no

WHERE de.to\_date=&#39;9999-01-01&#39;;

1. Total employees from each department that are eligible for mentorship program:
 ![Shape6](RackMultipart20220220-4-72k9di_html_32cc19f775af1e37.gif)

SELECT COUNT(dept\_name),

dept\_name

INTO total\_mentors\_in\_each\_dept

FROM mentors\_dept\_and\_salary

GROUP BY dept\_name;

1. Manager information by Department:

![Shape7](RackMultipart20220220-4-72k9di_html_32cc19f775af1e37.gif)

SELECT c.first\_name,c.last\_name,d.emp\_no,d.dept\_no

INTO manager\_each\_dept

FROM dept\_manager AS d

INNER JOIN employees AS c

ON d.emp\_no=c.emp\_no

WHERE d.to\_date=&#39;9999-01-01&#39;;

1. Employee&#39;s Manager info eligible for Mentorship Program:

![Shape8](RackMultipart20220220-4-72k9di_html_cd77c9a047f99b88.gif)

SELECT m.emp\_no,

m.first\_name,

m.last\_name,

m.dept\_name,

n.first\_name AS manager\_FN,

n.last\_name AS manager\_LN

INTO mentors\_manager\_info

FROM mentors\_dept\_and\_salary AS m

INNER JOIN manager\_each\_dept AS n

ON m.dept\_no=n.dept\_no;
