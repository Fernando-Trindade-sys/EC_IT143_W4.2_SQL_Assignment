USE Simpsons;
GO

CREATE VIEW v_employee_count_by_department
AS
SELECT
    Department,
    COUNT(*) AS Employee_Count
FROM Family_Data
GROUP BY Department;
GO