/*
********************************************************************************
******************************
NAME:       EC_IT143_W5.2_MyFC_FPT.sql
PURPOSE:    Answer four community data questions using the MyFC dataset.

MODIFICATION LOG:
Ver     Date        Author                       Description
------  ----------  ---------------------------  ---------------------------------
1.0     10/03/2026  Fernando Pereira Da Trindade 1. Built this script for EC IT143.

RUNTIME:
Xm Xs

NOTES:
This script contains four questions and SQL answers for the MyFC dataset.
At least one question was created by another student, as required.

********************************************************************************
******************************/

USE MyFC;
GO

-- Q1: Which players have the highest salaries within each position?
-- A1: This query ranks players by salary within each position and returns the highest-paid player. Question created by Fernando Pereira Da Trindade.

;WITH PositionSalaryRank AS
(
    SELECT
        pd.p_name AS Position,
        pl.pl_name AS PlayerName,
        MAX(pf.mtd_salary) AS HighestSalary,
        ROW_NUMBER() OVER
        (
            PARTITION BY pd.p_name
            ORDER BY MAX(pf.mtd_salary) DESC
        ) AS SalaryRank
    FROM dbo.tblPlayerFact AS pf
    INNER JOIN dbo.tblPlayerDim AS pl
        ON pf.pl_id = pl.pl_id
    INNER JOIN dbo.tblPositionDim AS pd
        ON pl.p_id = pd.p_id
    GROUP BY
        pd.p_name,
        pl.pl_name
)
SELECT
    Position,
    PlayerName,
    HighestSalary
FROM PositionSalaryRank
WHERE SalaryRank = 1
ORDER BY Position;
GO

-- Q2: How does average player salary vary by team and position?
-- A2: This query calculates the average player salary for each team and position. Question created by Fernando Pereira Da Trindade.

SELECT
    td.t_code AS Team,
    pd.p_name AS Position,
    AVG(pf.mtd_salary) AS AvgSalary
FROM dbo.tblPlayerFact AS pf
INNER JOIN dbo.tblPlayerDim AS pl
    ON pf.pl_id = pl.pl_id
INNER JOIN dbo.tblPositionDim AS pd
    ON pl.p_id = pd.p_id
INNER JOIN dbo.tblTeamDim AS td
    ON pl.t_id = td.t_id
GROUP BY
    td.t_code,
    pd.p_name
ORDER BY
    td.t_code,
    AvgSalary DESC;
GO

-- Q3: How have player salary expenses changed over the available reporting dates?
-- A3: This query totals player salary expenses for each available reporting date. Question created by Fernando Pereira Da Trindade.

SELECT
    as_of_date,
    SUM(mtd_salary) AS TotalSalary
FROM dbo.tblPlayerFact
GROUP BY as_of_date
ORDER BY as_of_date;
GO

-- Q4: Which teams have the highest total player salary expenses, and which positions contribute most to those costs?
-- A4: This query totals salary expense by team and position, ordered from highest to lowest. Question created by Kayega Musa in the EC IT143 W4.3 discussion.

SELECT
    td.t_code AS Team,
    pd.p_name AS Position,
    SUM(pf.mtd_salary) AS TotalSalaryExpense
FROM dbo.tblPlayerFact AS pf
INNER JOIN dbo.tblPlayerDim AS pl
    ON pf.pl_id = pl.pl_id
INNER JOIN dbo.tblPositionDim AS pd
    ON pl.p_id = pd.p_id
INNER JOIN dbo.tblTeamDim AS td
    ON pl.t_id = td.t_id
GROUP BY
    td.t_code,
    pd.p_name
ORDER BY TotalSalaryExpense DESC;
GO
