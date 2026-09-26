USE MyFC;
GO

CREATE VIEW v_player_count_by_team
AS
SELECT
    td.t_code AS Team,
    COUNT(pd.pl_id) AS Player_Count
FROM tblPlayerDim pd
INNER JOIN tblTeamDim td
    ON pd.t_id = td.t_id
GROUP BY
    td.t_code;
GO

USE MyFC;
GO

SELECT *
FROM v_player_count_by_team;