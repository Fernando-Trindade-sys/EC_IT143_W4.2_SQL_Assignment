USE EC_IT143_DA;
GO

/***************************************************************************************************
NAME:    EC_IT143_W6.2_fwf_FernandoTrindade.sql
PURPOSE: Fun with Functions - parse first and last names from ContactName

MODIFICATION LOG:
Ver      Date          Author                         Description
-----    ----------    -----------------------------  -----------------------------------------------
1.0      10/09/2026    Fernando Pereira Da Trindade   Built this script for EC IT143 Week 6.2.

RUNTIME:
Approximately 1 second.

NOTES:
Uses dbo.t_w3_schools_customers. The CASE expressions handle a ContactName that has no space,
such as Zbyszek, without passing a negative length to LEFT.
***************************************************************************************************/

--=================================================================================================
-- STEP 1 - START WITH A QUESTION
--=================================================================================================
-- Q1: How to extract the first name from ContactName?

--=================================================================================================
-- STEP 2 - BEGIN CREATING AN ANSWER
--=================================================================================================
-- A1: Locate the first space and return all characters before it.
--     If no space exists, return the complete ContactName.

--=================================================================================================
-- STEP 3 - CREATE AN AD HOC SQL QUERY
--=================================================================================================
SELECT
      t.ContactName
    , CASE
          WHEN CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) > 0
              THEN LEFT
                   (
                       LTRIM(RTRIM(t.ContactName)),
                       CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) - 1
                   )
          ELSE LTRIM(RTRIM(t.ContactName))
      END AS first_name
FROM dbo.t_w3_schools_customers AS t
ORDER BY t.ContactName;
GO

--=================================================================================================
-- STEP 4 - RESEARCH AND TEST A SOLUTION
--=================================================================================================
-- LEFT returns characters from the beginning of a string.
-- CHARINDEX identifies the position of the first space.
-- The CASE expression handles contacts with only one name.

SELECT
      t.ContactName
    , CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) AS first_space_position
    , CASE
          WHEN CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) > 0
              THEN LEFT
                   (
                       LTRIM(RTRIM(t.ContactName)),
                       CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) - 1
                   )
          ELSE LTRIM(RTRIM(t.ContactName))
      END AS expected_first_name
FROM dbo.t_w3_schools_customers AS t
WHERE t.ContactName IN ('Maria Anders', 'Ana Trujillo', 'Zbyszek')
ORDER BY t.ContactName;
GO

--=================================================================================================
-- STEP 5 - CREATE A USER-DEFINED SCALAR FUNCTION
--=================================================================================================
CREATE OR ALTER FUNCTION dbo.ufn_FirstName
(
    @ContactName VARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @FirstName VARCHAR(100);
    DECLARE @CleanName VARCHAR(100) = LTRIM(RTRIM(@ContactName));

    SET @FirstName =
        CASE
            WHEN @CleanName IS NULL THEN NULL
            WHEN CHARINDEX(' ', @CleanName) > 0
                THEN LEFT(@CleanName, CHARINDEX(' ', @CleanName) - 1)
            ELSE @CleanName
        END;

    RETURN @FirstName;
END;
GO

--=================================================================================================
-- STEP 6 - COMPARE UDF RESULTS TO AD HOC QUERY RESULTS
--=================================================================================================
SELECT
      t.ContactName
    , CASE
          WHEN CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) > 0
              THEN LEFT
                   (
                       LTRIM(RTRIM(t.ContactName)),
                       CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) - 1
                   )
          ELSE LTRIM(RTRIM(t.ContactName))
      END AS first_name_ad_hoc
    , dbo.ufn_FirstName(t.ContactName) AS first_name_udf
FROM dbo.t_w3_schools_customers AS t
ORDER BY t.ContactName;
GO

--=================================================================================================
-- STEP 7 - PERFORM A 0-RESULTS-EXPECTED TEST
--=================================================================================================
;WITH FirstNameComparison AS
(
    SELECT
          t.CustomerID
        , t.ContactName
        , CASE
              WHEN CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) > 0
                  THEN LEFT
                       (
                           LTRIM(RTRIM(t.ContactName)),
                           CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) - 1
                       )
              ELSE LTRIM(RTRIM(t.ContactName))
          END AS first_name_ad_hoc
        , dbo.ufn_FirstName(t.ContactName) AS first_name_udf
    FROM dbo.t_w3_schools_customers AS t
)
SELECT *
FROM FirstNameComparison
WHERE ISNULL(first_name_ad_hoc, '') <> ISNULL(first_name_udf, '');
-- Expected result: 0 rows.
GO

--=================================================================================================
-- STEP 8 - ASK THE NEXT QUESTION
--=================================================================================================
-- Q2: How to extract the last name from ContactName?

--=================================================================================================
-- STEP 9 - BEGIN CREATING AN ANSWER
--=================================================================================================
-- A2: Return all characters after the first space.
--     If no space exists, return the complete ContactName, matching the agreed class solution.

--=================================================================================================
-- STEP 10 - CREATE AN AD HOC SQL QUERY
--=================================================================================================
SELECT
      t.ContactName
    , CASE
          WHEN CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) > 0
              THEN SUBSTRING
                   (
                       LTRIM(RTRIM(t.ContactName)),
                       CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) + 1,
                       LEN(LTRIM(RTRIM(t.ContactName)))
                   )
          ELSE LTRIM(RTRIM(t.ContactName))
      END AS last_name
FROM dbo.t_w3_schools_customers AS t
ORDER BY t.ContactName;
GO

--=================================================================================================
-- STEP 11 - RESEARCH AND TEST A SOLUTION
--=================================================================================================
-- SUBSTRING starts immediately after the first space and returns the remaining characters.

SELECT
      t.ContactName
    , CASE
          WHEN CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) > 0
              THEN SUBSTRING
                   (
                       LTRIM(RTRIM(t.ContactName)),
                       CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) + 1,
                       LEN(LTRIM(RTRIM(t.ContactName)))
                   )
          ELSE LTRIM(RTRIM(t.ContactName))
      END AS expected_last_name
FROM dbo.t_w3_schools_customers AS t
WHERE t.ContactName IN ('Maria Anders', 'Ana Trujillo', 'Zbyszek')
ORDER BY t.ContactName;
GO

--=================================================================================================
-- STEP 12 - CREATE A USER-DEFINED SCALAR FUNCTION
--=================================================================================================
CREATE OR ALTER FUNCTION dbo.ufn_LastName
(
    @ContactName VARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @LastName VARCHAR(100);
    DECLARE @CleanName VARCHAR(100) = LTRIM(RTRIM(@ContactName));

    SET @LastName =
        CASE
            WHEN @CleanName IS NULL THEN NULL
            WHEN CHARINDEX(' ', @CleanName) > 0
                THEN SUBSTRING
                     (
                         @CleanName,
                         CHARINDEX(' ', @CleanName) + 1,
                         LEN(@CleanName)
                     )
            ELSE @CleanName
        END;

    RETURN @LastName;
END;
GO

--=================================================================================================
-- STEP 13 - COMPARE UDF RESULTS TO AD HOC QUERY RESULTS
--=================================================================================================
SELECT
      t.ContactName
    , CASE
          WHEN CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) > 0
              THEN SUBSTRING
                   (
                       LTRIM(RTRIM(t.ContactName)),
                       CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) + 1,
                       LEN(LTRIM(RTRIM(t.ContactName)))
                   )
          ELSE LTRIM(RTRIM(t.ContactName))
      END AS last_name_ad_hoc
    , dbo.ufn_LastName(t.ContactName) AS last_name_udf
FROM dbo.t_w3_schools_customers AS t
ORDER BY t.ContactName;
GO

--=================================================================================================
-- STEP 14 - PERFORM A 0-RESULTS-EXPECTED TEST
--=================================================================================================
;WITH LastNameComparison AS
(
    SELECT
          t.CustomerID
        , t.ContactName
        , CASE
              WHEN CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) > 0
                  THEN SUBSTRING
                       (
                           LTRIM(RTRIM(t.ContactName)),
                           CHARINDEX(' ', LTRIM(RTRIM(t.ContactName))) + 1,
                           LEN(LTRIM(RTRIM(t.ContactName)))
                       )
              ELSE LTRIM(RTRIM(t.ContactName))
          END AS last_name_ad_hoc
        , dbo.ufn_LastName(t.ContactName) AS last_name_udf
    FROM dbo.t_w3_schools_customers AS t
)
SELECT *
FROM LastNameComparison
WHERE ISNULL(last_name_ad_hoc, '') <> ISNULL(last_name_udf, '');
-- Expected result: 0 rows.
GO

-- Final demonstration of both scalar functions.
SELECT
      t.CustomerID
    , t.CustomerName
    , t.ContactName
    , dbo.ufn_FirstName(t.ContactName) AS ContactName_FirstName
    , dbo.ufn_LastName(t.ContactName) AS ContactName_LastName
    , t.Address
    , t.City
    , t.Country
FROM dbo.t_w3_schools_customers AS t
ORDER BY t.ContactName;
GO
