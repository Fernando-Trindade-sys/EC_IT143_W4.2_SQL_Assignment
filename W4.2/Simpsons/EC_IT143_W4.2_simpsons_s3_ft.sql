USE Simpsons;
GO

SELECT
    Department,
    COUNT(*) AS Employee_Count
FROM Family_Data
GROUP BY Department;