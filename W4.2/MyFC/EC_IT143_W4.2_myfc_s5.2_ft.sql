USE MyFC;
GO

ALTER TABLE player_count_by_team
ADD player_count_by_team_id INT IDENTITY(1,1);

ALTER TABLE player_count_by_team
ADD CONSTRAINT PK_player_count_by_team
PRIMARY KEY (player_count_by_team_id);
GO