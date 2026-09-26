USE Simpsons;
GO

TRUNCATE TABLE employee_count_by_department;

INSERT INTO employee_count_by_department
(
    Department,
    Employee_Count
)
SELECT
    Department,
    Employee_Count
FROM v_employee_count_by_department;
GO