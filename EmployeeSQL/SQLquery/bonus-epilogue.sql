-- Bonus: Epilogue

-- Display employee#499942
SELECT * FROM employees
WHERE emp_no = 499942;

-- Found that first name, last name and hire date is incorrect
-- Update employee info to my name and hire_date
UPDATE employees
SET (last_name, first_name, hire_date) = ('Christmas', 'Merry', '2020-12-25')
WHERE emp_no = 499942;

-- Select columns to display after info. updated
SELECT e.emp_no, e.last_name, e.first_name, e.hire_date, d.dept_name
-- Get employees table as the first table to join other tables
FROM employees AS e
	-- Join dept_emp table to get dept_no to link to department name in department table
	JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
		-- Join departments table to have department name
		JOIN departments AS d
		ON de.dept_no = d.dept_no
-- Apply condition to filter only employee#499942
WHERE e.emp_no = 499942;



