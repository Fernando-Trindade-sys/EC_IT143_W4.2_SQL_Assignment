USE MyFC;
GO

SELECT
    td.t_code AS Team,
    COUNT(pd.pl_id) AS Player_Count
FROM tblPlayerDim pd
INNER JOIN tblTeamDim td
    ON pd.t_id = td.t_id
GROUP BY
    td.t_code;
