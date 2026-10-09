USE EC_IT143_DA;
GO

/***************************************************************************************************
NAME:    EC_IT143_W6.2_fwt_FernandoTrindade.sql
PURPOSE: Fun with Triggers - track who last modified a customer row and when it was modified

MODIFICATION LOG:
Ver      Date          Author                         Description
-----    ----------    -----------------------------  -----------------------------------------------
1.0      10/09/2026    Fernando Pereira Da Trindade   Built this script for EC IT143 Week 6.2.

RUNTIME:
Approximately 1 second.

NOTES:
Uses dbo.t_w3_schools_customers. The script checks whether the audit columns already exist before
adding them, allowing the script to be executed safely after the classroom tests already completed.
The trigger is set-based and supports updates affecting one or multiple rows.
***************************************************************************************************/

--=================================================================================================
-- STEP 1 - START WITH A QUESTION
--=================================================================================================
-- Q1: How to keep track of when a record was last modified?

--=================================================================================================
-- STEP 2 - BEGIN CREATING AN ANSWER
--=================================================================================================
-- A1: Add a LastModifiedDate column and use an AFTER UPDATE trigger to set its value automatically.

-- Add the date column only when it does not already exist.
IF COL_LENGTH('dbo.t_w3_schools_customers', 'LastModifiedDate') IS NULL
BEGIN
    ALTER TABLE dbo.t_w3_schools_customers
    ADD LastModifiedDate DATETIME NULL;
END;
GO

--=================================================================================================
-- STEP 3 - RESEARCH AND TEST A SOLUTION
--=================================================================================================
-- GETDATE() returns the SQL Server date and time at which the update is processed.
SELECT GETDATE() AS current_sql_server_date_time;
GO

--=================================================================================================
-- STEP 4 - ASK THE NEXT QUESTION
--=================================================================================================
-- Q2: How to keep track of who last modified a record?

-- A2: Add a LastModifiedBy column and use SYSTEM_USER inside the same AFTER UPDATE trigger.

-- Add the user column only when it does not already exist.
IF COL_LENGTH('dbo.t_w3_schools_customers', 'LastModifiedBy') IS NULL
BEGIN
    ALTER TABLE dbo.t_w3_schools_customers
    ADD LastModifiedBy VARCHAR(128) NULL;
END;
GO

-- Review the audit columns before creating the trigger.
SELECT
      c.COLUMN_NAME
    , c.DATA_TYPE
    , c.CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE c.TABLE_SCHEMA = 'dbo'
  AND c.TABLE_NAME = 't_w3_schools_customers'
  AND c.COLUMN_NAME IN ('LastModifiedBy', 'LastModifiedDate')
ORDER BY c.ORDINAL_POSITION;
GO

--=================================================================================================
-- STEP 5 - CREATE AN AFTER-UPDATE TRIGGER
--=================================================================================================
CREATE OR ALTER TRIGGER dbo.trg_LastModified
ON dbo.t_w3_schools_customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Prevent unnecessary recursion if recursive triggers are enabled.
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;

    UPDATE c
       SET c.LastModifiedBy   = SYSTEM_USER,
           c.LastModifiedDate = GETDATE()
    FROM dbo.t_w3_schools_customers AS c
    INNER JOIN inserted AS i
        ON i.CustomerID = c.CustomerID;
END;
GO

--=================================================================================================
-- STEP 6 - TEST RESULTS TO SEE IF THEY ARE AS EXPECTED
--=================================================================================================
-- Store the original value so the test can restore the row at the end.
DECLARE @OriginalCity VARCHAR(15);
SET @OriginalCity =
(
    SELECT City
    FROM dbo.t_w3_schools_customers
    WHERE CustomerID = 1
);

-- Test one updated row.
UPDATE dbo.t_w3_schools_customers
SET City = 'Berlin Test'
WHERE CustomerID = 1;

SELECT
      CustomerID
    , CustomerName
    , City
    , LastModifiedBy
    , LastModifiedDate
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 1;

-- Restore the original City. This UPDATE also correctly fires the trigger.
UPDATE dbo.t_w3_schools_customers
SET City = @OriginalCity
WHERE CustomerID = 1;

SELECT
      CustomerID
    , CustomerName
    , City
    , LastModifiedBy
    , LastModifiedDate
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 1;
GO

--=================================================================================================
-- STEP 7 - OPTIONAL SET-BASED TEST
--=================================================================================================
-- This update intentionally assigns City to its existing value. SQL Server still processes the
-- UPDATE, so the trigger should audit both rows and prove that it handles multi-row operations.
UPDATE dbo.t_w3_schools_customers
SET City = City
WHERE CustomerID IN (2, 3);

SELECT
      CustomerID
    , CustomerName
    , City
    , LastModifiedBy
    , LastModifiedDate
FROM dbo.t_w3_schools_customers
WHERE CustomerID IN (2, 3)
ORDER BY CustomerID;
GO

-- Final verification: the trigger exists and is enabled.
SELECT
      tr.name AS trigger_name
    , tr.is_disabled
    , OBJECT_NAME(tr.parent_id) AS parent_table
FROM sys.triggers AS tr
WHERE tr.name = 'trg_LastModified';
GO
