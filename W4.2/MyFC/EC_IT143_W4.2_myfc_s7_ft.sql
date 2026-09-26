USE MyFC;
GO

CREATE PROCEDURE usp_load_player_count_by_team
AS
BEGIN

    TRUNCATE TABLE player_count_by_team;

    INSERT INTO player_count_by_team
    (
        Team,
        Player_Count
    )
    SELECT
        Team,
        Player_Count
    FROM v_player_count_by_team;

END
GO