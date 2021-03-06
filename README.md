# A Mystery in Two Parts

## Background

As a new data engineer at Pewlett Hackard, a research project on employees of the corporation from 1980s and 1990s was assigned. There are 2 parts of this project; data engineering and data analysis. The process contains designing the tables to hold data in the CSVs, importing the CSVs into a SQL database, and answering questions about the data. 

## Data Engineering

### Entity Relationship Diagram (ERD)

**Many-to-one relationship**
        
* emp_no in employees table and emp_no in dept_emp tables
* emp_no in employees table and emp_no in dept_manager tables
* title_id in titles table and emp_title_id in employees table
* dept_no in departments table and dept_no in dept_emp tables.
* dept_no in departments table and dept_no in dept_manager tables

**One-to-one relationship**

* emp_no in employees table and emp_no in salaries table


![Employee_ERD](EmployeeSQL/Images/employee_DBD.png)

### Database

- Create `employee_db` database in PostgreSQL 
- Import [schema](EmployeeSQL/SQLquery/employee_schema.sql) into database created
- Import [csv files](EmployeeSQL/Resources) to tables created as the following order:

  * [titles](EmployeeSQL/Resources/titles.csv)
  * [employees](EmployeeSQL/Resources/employees.csv)
  * [departments](EmployeeSQL/Resources/departments.csv)
  * [dept_emp](EmployeeSQL/Resources/dept_emp.csv)
  * [dept_manager](EmployeeSQL/Resources/dept_manager.csv)
  * [salaries](EmployeeSQL/Resources/salaries.csv)

---
## Data Analysis
*Including a query excecuted in order to answer each question.*

### Part I: Reserch Questions
 
- **List the following details of each employee: employee number, last name, first name, sex, and salary.** [(Query-1)](EmployeeSQL/SQLquery/Q1.sql) 


        SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
        FROM employees AS e
        LEFT JOIN salaries AS s
        ON e.emp_no = s.emp_no;


---
- **List first name, last name, and hire date for employees who were hired in 1986.** [(Query-2)](EmployeeSQL/SQLquery/Q2.sql) 


        SELECT first_name, last_name, hire_date
        FROM employees
        WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';


---
- **List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.** [(Query-3)](EmployeeSQL/SQLquery/Q3.sql)


        SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
        FROM dept_manager AS dm
        JOIN departments AS d 
        ON dm.dept_no = d.dept_no
        JOIN employees AS e 
        ON dm.emp_no = e.emp_no;


---
- **List the department of each employee with the following information: employee number, last name, first name, and department name.** [(Query-4)](EmployeeSQL/SQLquery/Q4.sql)


        SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
        FROM employees AS e
        JOIN dept_emp AS de
        ON e.emp_no = de.emp_no
        JOIN departments AS d
        ON de.dept_no = d.dept_no;


---
- **List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."** [(Query-5)](EmployeeSQL/SQLquery/Q5.sql) 


        SELECT first_name, last_name, sex
        FROM employees 
        WHERE first_name = 'Hercules'
        AND last_name LIKE 'B%';


---
- **List all employees in the Sales department, including their employee number, last name, first name, and department name.** [(Query-6)](EmployeeSQL/SQLquery/Q6.sql) 


        SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
        FROM employees AS e
        JOIN dept_emp AS de
        ON e.emp_no = de.emp_no
        JOIN departments AS d
        ON de.dept_no = d.dept_no
        WHERE d.dept_name = 'Sales';


---
- **List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.** [(Query-7)](EmployeeSQL/SQLquery/Q7.sql) 


        SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
        FROM employees AS e
        JOIN dept_emp AS de
        ON e.emp_no = de.emp_no
        JOIN departments AS d
        ON de.dept_no = d.dept_no
        WHERE d.dept_name IN ('Sales', 'Development');


---
- **In descending order, list the frequency count of employee last names.** [(Query-8)](EmployeeSQL/SQLquery/Q8.sql) 


        SELECT last_name,
        COUNT(*) AS "Frequency of Last name"
        FROM employees
        GROUP BY last_name
        ORDER BY "Frequency of Last name" DESC;


---
### Part I: Bonus
*Import database into Jupyter Notebook to visualize the data*

**Bonus-I: The most common salary**

- The most common salary for Pewlett Hackard's employees is between $40,000 and $50,000. [(See Jupyter Notebook)](https://nbviewer.jupyter.org/github/abpuccini/sql-challenge/blob/main/Employee_DB.ipynb)

<p align="center">
  <img src="EmployeeSQL/Images/salary_range.png">
</p>

---

**Bonus-II:** Average salary by title

- In postgres: Calculation of average salary by title which is stored in view. [(See Query)](EmployeeSQL/SQLquery/bonus_q2.sql) 


        CREATE VIEW "avg_salary_title" AS
        SELECT t.title,
        ROUND(AVG(s.salary),2) AS "avg salary"
        FROM employees AS e 
        JOIN salaries AS s
        ON e.emp_no = s.emp_no
        JOIN titles AS t
        ON e.emp_title_id = t.title_id
        GROUP BY t.title;

        SELECT * FROM avg_salary_title;


- In Jupyter Notebook: Import view to visualize data. [(See Jupyter Notebook)](https://nbviewer.jupyter.org/github/abpuccini/sql-challenge/blob/main/Employee_DB.ipynb) 

<p align="center">
  <img src="Images/avg_salary_title.png">
</p>

---

**Epilogue:** [See Query](EmployeeSQL/SQLquery/bonus-epilogue.sql)

After giving a presentation to my boss, I heard the word, "Search your ID number." Then, I looked up for ID 499942 and found that the name and hire date were incorrect. That name was April Foolday and hire date is before I was born. Therefore, I updated first name, last name and hire date. Then, displying the information of employee number 499942 again. :wink:   


        SELECT * FROM employees
        WHERE emp_no = 499942;

        UPDATE employees
        SET (last_name, first_name, hire_date) = ('Christmas', 'Merry', '2020-12-25')
        WHERE emp_no = 499942;

        SELECT e.emp_no, e.last_name, e.first_name, e.hire_date, d.dept_name
        FROM employees AS e
        JOIN dept_emp AS de
        ON e.emp_no = de.emp_no
        JOIN departments AS d
        ON de.dept_no = d.dept_no
        WHERE e.emp_no = 499942;


---
© [Atcharaporn B Puccini](https://www.linkedin.com/in/atcharaporn-puccini-233614118)
