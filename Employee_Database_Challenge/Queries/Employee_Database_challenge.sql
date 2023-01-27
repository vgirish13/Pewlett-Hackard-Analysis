
CREATE TABLE departments (
  dept_no VARCHAR(4) NOT NULL,
  dept_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (dept_no),
  UNIQUE (dept_name)
);

CREATE TABLE employees (
  emp_no INT NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);

SELECT employees.emp_no
	,employees.first_name
	,employees.last_name
	,titles.title
	,titles.from_date
	,titles.to_date
INTO retirement_titles
FROM employees
INNER JOIN titles
ON employees.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY employees.emp_no
;

SELECT * FROM retirement_titles
;

SELECT DISTINCT ON (emp_no) emp_no
,first_name
,last_name
,title

INTO current_title
FROM retirement_titles
WHERE to_date = ('9999-01-01')
ORDER BY emp_no
,title DESC
;

SELECT * FROM current_title
;

SELECT retirement_titles.emp_no
, retirement_titles.first_name
, retirement_titles.last_name
,current_title.title
INTO unique_titles
FROM retirement_titles
INNER JOIN current_title
ON retirement_titles.emp_no = current_title.emp_no
WHERE to_date = ('9999-01-01')
ORDER BY retirement_titles.to_date DESC, retirement_titles.emp_no
;

SELECT * FROM unique_titles
;

SELECT COUNT (title)
FROM unique_titles

	SELECT COUNT (unique_titles.title)
	,title
	INTO retiring_titles
	FROM unique_titles
	GROUP BY unique_titles.title
	ORDER BY count DESC
;

SELECT * FROM retiring_titles
ORDER BY count DESC

-- Deliverable 2

SELECT employees.emp_no
	,employees.first_name
	,employees.last_name
	,employees.birth_date
	,dept_emp.from_date
	,dept_emp.to_date
INTO current_employees
FROM employees 
INNER JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
ORDER BY employees.emp_no
;
		
SELECT * FROM current_employees


SELECT employees.emp_no
	,employees.first_name
	,employees.last_name
	,employees.birth_date
	,titles.title
	,titles.from_date
	,titles.to_date
INTO eligible_titles
FROM employees 
INNER JOIN titles
ON employees.emp_no = titles.emp_no
ORDER BY employees.emp_no
;
		
SELECT * FROM eligible_titles	
	
SELECT DISTINCT ON (emp_no) emp_no
	,first_name
	,last_name
	,birth_date
	,title
	,from_date
	to_date
INTO eligible_employees
FROM eligible_titles
WHERE to_date = ('9999-01-01')
ORDER BY emp_no, title DESC
;

SELECT * FROM eligible_employees
;
	

SELECT DISTINCT ON (eligible_titles.emp_no) eligible_employees.emp_no
	,eligible_employees.first_name
	,eligible_employees.last_name
	,eligible_employees.birth_date
	,eligible_titles.from_date
	,eligible_titles.to_date
	,eligible_titles.title
INTO membership_eligibility
FROM eligible_employees
INNER JOIN eligible_titles
ON eligible_employees.emp_no = eligible_titles.emp_no
WHERE eligible_employees.birth_date BETWEEN ('1965-01-01') AND ('1965-12-31')
ORDER BY eligible_titles.emp_no ASC, eligible_employees.birth_date DESC
; 

SELECT * FROM membership_eligibility
;