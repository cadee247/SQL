-- Step 1: Create the 'employees' table to store basic employee info
CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,  -- Unique ID for each employee
  name TEXT,                       -- Employee's name
  department TEXT,                 -- Department they belong to
  hire_date DATE                   -- Date they were hired
);

-- Step 2: Insert sample employee records into 'employees'
INSERT INTO employees (name, department, hire_date)
VALUES
  ('Cadee', 'Engineer', '2022-03-01'),
  ('Lindo', 'Development', '2021-07-15'),
  ('Alex', 'Full stack developer', '2023-01-10');

-- Create 'employee_details' table to store additional info like age and salary
CREATE TABLE employee_details (
  employee_id INT REFERENCES employees(employee_id),  -- Foreign key to 'employees'
  age INT,                                            -- Age of the employee
  monthly_salary NUMERIC                              -- Monthly salary
);

-- Insert corresponding details for each employee
INSERT INTO employee_details (employee_id, age, monthly_salary)
VALUES
  (1, 29, 25000),
  (2, 32, 30000),
  (3, 27, 22000);

-- Query to display employee info with salary analysis
SELECT
  e.name,
  e.department,
  d.age,
  d.monthly_salary,
  (d.monthly_salary * 12) AS annual_salary,  -- Calculate annual salary
  ROUND(
    ((d.monthly_salary - avg_salary.avg_monthly) / avg_salary.avg_monthly) * 100,
    2
  ) AS percent_above_avg,  -- % difference from average salary
  (d.monthly_salary > avg_salary.avg_monthly)::int - 
  (d.monthly_salary < avg_salary.avg_monthly)::int AS salary_band_score  -- +1 if above avg, -1 if below, 0 if equal
FROM employees e
JOIN employee_details d ON e.employee_id = d.employee_id
JOIN (
  SELECT AVG(monthly_salary) AS avg_monthly
  FROM employee_details
) avg_salary ON TRUE;  -- Cross join to include average salary in all rows

-- Create 'roles' table to define job roles and base salaries
CREATE TABLE roles (
  role_id SERIAL PRIMARY KEY,
  role_name VARCHAR(50) UNIQUE,     -- Unique role name
  role_description TEXT,            -- Description of the role
  base_salary INTEGER               -- Base salary for the role
);

-- Insert sample roles
INSERT INTO roles (role_name, role_description, base_salary) VALUES
('Graphic Designer', 'Helps with video editing, photo editing and market advertisement designs', 35000),
('Videographer', 'Helps with all digital media productions', 18000),
('Social Marketer', 'Helps with social media strategies and social data', 26000),
('Sales Rep', 'Helps promote and sign clients', 20000);

-- View all roles
SELECT * FROM roles;

-- Create 'task_employees' table to simulate another employee dataset with roles and sales
CREATE TABLE task_employees (
  employee_id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  birthdate DATE,
  role_name VARCHAR(50),
  sales INTEGER DEFAULT 0  -- Only relevant for Sales Reps
);

-- Insert sample task employees
INSERT INTO task_employees (name, birthdate, role_name, sales) VALUES
('Aragorn', '1994-08-24', 'Sales Rep', 22),
('Gandalf', '1982-05-11', 'Graphic Designer', 0),
('Frodo', '1990-01-18', 'Videographer', 0),
('Legolas', '1998-04-22', 'Social Marketer', 0),
('Gimli', '2000-11-08', 'Sales Rep', 10),
('Samwise', '2001-01-01', 'Sales Rep', 9),
('Pippin', '1999-09-26', 'Sales Rep', 18),
('Merry', '2005-08-07', 'Social Marketer', 0);

-- Query to find employees older than 27 years
SELECT 
  name, 
  birthdate, 
  role_name
FROM 
  task_employees
WHERE 
  AGE(CURRENT_DATE, birthdate) > INTERVAL '27 years';

-- Salary calculation and age flag for task employees
SELECT 
  e.name,
  e.birthdate,
  e.role_name,
  r.role_description,
  r.base_salary,
  CASE 
    WHEN e.role_name = 'Sales Rep' AND e.sales > 10 
      THEN r.base_salary + 200 * (e.sales - 10)  -- Bonus for Sales Reps with >10 sales
    WHEN e.role_name = 'Sales Rep'
      THEN r.base_salary                         -- No bonus if sales ≤10
    ELSE r.base_salary                           -- Base salary for other roles
  END AS total_salary,
  CASE 
    WHEN AGE(CURRENT_DATE, e.birthdate) > INTERVAL '27 years' THEN 'Yes'
    ELSE 'No'
  END AS older_than_27  -- Flag if employee is older than 27
FROM 
  task_employees e
JOIN 
 roles r ON e.role_name = r.role_name;