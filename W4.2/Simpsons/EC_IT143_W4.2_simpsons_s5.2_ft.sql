USE Simpsons;
GO

ALTER TABLE employee_count_by_department
ADD employee_count_by_department_id INT IDENTITY(1,1);

ALTER TABLE employee_count_by_department
ADD CONSTRAINT PK_employee_count_by_department
PRIMARY KEY (employee_count_by_department_id);
GO