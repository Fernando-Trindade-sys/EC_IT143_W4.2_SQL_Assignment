/*
=====================================================================
Student Name: Fernando Pereira Da Trindade
Course: IT143 Database Management Systems
Assignment: Exercise 6.3 - Performance Analysis and SQL Server Profiler
Database: AdventureWorks2022


Description:
This script demonstrates how to identify Missing Index
Recommendations using Execution Plans and how creating
recommended indexes can improve query performance.
=====================================================================
*/

USE AdventureWorks2022;
GO

/********************************************************************
PART 1 - QUERY USING CITY COLUMN
********************************************************************/

/*
Step 1:
Execute the query and review the Actual Execution Plan.

Expected Result:
- Missing Index Recommendation
- Approximate Impact: 91%
- Index Scan operation
*/

SELECT *
FROM Person.Address
WHERE City = 'Bothell';
GO


/*
Step 2:
Create the recommended Nonclustered Index.
*/

CREATE NONCLUSTERED INDEX IX_Address_City
ON Person.Address (City);
GO


/*
Step 3:
Execute the query again.

Expected Result:
- Missing Index recommendation disappears.
- Index Seek replaces Index Scan.
- Improved query performance.
*/

SELECT *
FROM Person.Address
WHERE City = 'Bothell';
GO


/********************************************************************
PART 2 - QUERY USING POSTALCODE COLUMN
********************************************************************/

/*
Step 4:
Execute the query and review the Actual Execution Plan.

Expected Result:
- Missing Index Recommendation
- Approximate Impact: 92%
- Index Scan operation
*/

SELECT *
FROM Person.Address
WHERE PostalCode = '98011';
GO


/*
Step 5:
Create the recommended Nonclustered Index.
*/

CREATE NONCLUSTERED INDEX IX_Address_PostalCode
ON Person.Address (PostalCode);
GO


/*
Step 6:
Execute the query again.

Expected Result:
- Missing Index recommendation disappears.
- Index Seek replaces Index Scan.
- Improved query performance.
*/

SELECT *
FROM Person.Address
WHERE PostalCode = '98011';
GO


/********************************************************************
SQL SERVER PROFILER QUESTIONS
********************************************************************/

/*
Question 1:
What are some uses for SQL Server Profiler?

Answer:
SQL Server Profiler is used to monitor and analyze SQL
Server activity. It helps identify slow-running queries,
troubleshoot performance issues, capture database events,
monitor user activity, and collect workload information
for performance tuning and optimization.
*/


/*
Question 2:
What are the major steps you need to follow to use
SQL Server Profiler?

Answer:
1. Open SQL Server Profiler.
2. Connect to the SQL Server instance.
3. Create a new trace.
4. Select the events to capture.
5. Start the trace.
6. Perform the database activity.
7. Review and analyze the captured events.
8. Save the trace results if necessary.
*/


/********************************************************************
END OF SCRIPT
********************************************************************/