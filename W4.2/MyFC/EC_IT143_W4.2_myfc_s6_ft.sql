USE MyFC;
GO

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
GO