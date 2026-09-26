USE Simpsons;
GO

CREATE PROCEDURE usp_load_employee_count_by_department
AS
BEGIN

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

END
GO