TRUNCATE TABLE hello_world;

INSERT INTO hello_world
(
    Greeting
)
SELECT
    Greeting
FROM v_hello_world;
GO