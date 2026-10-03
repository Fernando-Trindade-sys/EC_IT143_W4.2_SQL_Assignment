/*
********************************************************************************
******************************
NAME:       EC_IT143_W5.2_Simpsons_FPT.sql
PURPOSE:    Answer four community data questions using the Simpsons dataset.

MODIFICATION LOG:
Ver     Date        Author                       Description
------  ----------  ---------------------------  ---------------------------------
1.0     10/03/2026  Fernando Pereira Da Trindade 1. Built this script for EC IT143.

RUNTIME:
Xm Xs

NOTES:
This script contains four questions and SQL answers for the Simpsons dataset.
At least one question was created by another student, as required.

********************************************************************************
******************************/

USE Simpsons;
GO

-- Q1: How do household characteristics differ across the family records, and which characteristics are most common in the community?
-- A1: This query counts family records by department to identify the most common characteristic. Question created by Fernando Pereira Da Trindade.

SELECT
    Department,
    COUNT(*) AS TotalMembers
FROM dbo.Family_Data
GROUP BY Department
ORDER BY TotalMembers DESC;
GO

-- Q2: How do the available cost records vary across categories or individuals represented in FBS_Viza_Costmo?
-- A2: This query compares total debit and credit records for each family member. Question created by Fernando Pereira Da Trindade.

SELECT
    Member_Name,
    SUM(ISNULL(Debit, 0)) AS TotalDebit,
    SUM(ISNULL(Credit, 0)) AS TotalCredit
FROM dbo.FBS_Viza_Costmo
GROUP BY Member_Name
ORDER BY TotalDebit DESC;
GO

-- Q3: Which people, destinations, or activities in Planet_Express are associated with the highest recorded operational values?
-- A3: This query totals Planet Express transaction amounts by card member. Question created by Fernando Pereira Da Trindade.

SELECT
    Card_Member,
    SUM(Amount) AS TotalAmount
FROM dbo.Planet_Express
GROUP BY Card_Member
ORDER BY TotalAmount DESC;
GO

-- Q4: Which family members have the highest total transaction amounts across both Visa and Planet Express records?
-- A4: This query combines Visa and Planet Express totals for each family member. Question created by Kayega Musa in the EC IT143 W4.3 discussion.

;WITH VisaTotals AS
(
    SELECT
        Member_Name,
        SUM(ISNULL(Debit, 0)) + SUM(ISNULL(Credit, 0)) AS VisaNetAmount
    FROM dbo.FBS_Viza_Costmo
    GROUP BY Member_Name
),
PlanetExpressTotals AS
(
    SELECT
        Card_Member,
        SUM(ISNULL(Amount, 0)) AS PlanetExpressAmount
    FROM dbo.Planet_Express
    GROUP BY Card_Member
)
SELECT
    f.Name AS FamilyMember,
    f.Job_Title,
    ISNULL(v.VisaNetAmount, 0) AS VisaNetAmount,
    ISNULL(p.PlanetExpressAmount, 0) AS PlanetExpressAmount,
    ISNULL(v.VisaNetAmount, 0) + ISNULL(p.PlanetExpressAmount, 0)
        AS CombinedTransactionAmount
FROM dbo.Family_Data AS f
LEFT JOIN VisaTotals AS v
    ON UPPER(LTRIM(RTRIM(f.Name))) = UPPER(LTRIM(RTRIM(v.Member_Name)))
LEFT JOIN PlanetExpressTotals AS p
    ON UPPER(LTRIM(RTRIM(f.Name))) = UPPER(LTRIM(RTRIM(p.Card_Member)))
ORDER BY CombinedTransactionAmount DESC;
GO
