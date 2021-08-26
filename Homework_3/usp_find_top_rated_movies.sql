USE movie_ratings_db;

DROP FUNCTION IF EXISTS get_year_from_title;

CREATE FUNCTION get_year_from_title(title VARCHAR(500)) RETURNS INT
    DETERMINISTIC
    RETURN (CAST(REGEXP_SUBSTR(title, '(?<=\\()\\d+?(?=\\))') AS UNSIGNED));


DROP FUNCTION IF EXISTS SPLIT_STR;

CREATE FUNCTION SPLIT_STR(
  x VARCHAR(255),
  delim VARCHAR(12),
  pos INT
)
RETURNS VARCHAR(255)
DETERMINISTIC
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, '');

DROP PROCEDURE IF EXISTS get_top_movies;

DELIMITER $$
CREATE PROCEDURE get_top_movies(IN n INT,
    IN title_regexp VARCHAR(500),
    IN year_from INT,
    IN year_to INT,
    IN genre VARCHAR(100))
BEGIN
    DECLARE limit_var INT;
    SET limit_var = COALESCE(n, 1000000000);
    SELECT title, avg(rating) as avg_rating, genres
    FROM movies
    JOIN ratings r on movies.movieId = r.movieId
    WHERE ((genre IS NULL) OR (movies.genres LIKE CONCAT('%', genre, '%')))
        AND (((year_from IS NULL) OR (get_year_from_title(movies.title) >= year_from))
        AND ((year_to IS NULL) OR (get_year_from_title(movies.title) <= year_to)))
        AND ((title_regexp IS NULL) OR (movies.title REGEXP title_regexp))
    group by movies.movieId, title, genres
    order by avg_rating desc
    LIMIT limit_var;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS usp_find_top_rated_movies;

DELIMITER $$
CREATE PROCEDURE usp_find_top_rated_movies(
    IN n INT,
    IN title_regexp VARCHAR(500),
    IN year_from INT,
    IN year_to INT,
    IN in_genres VARCHAR(100))
BEGIN
    DECLARE i INT Default 0;
    DECLARE genre VARCHAR(50);

    IF in_genres is NULL THEN
        CALL get_top_movies(n, title_regexp, year_from, year_to, in_genres);
    ELSE
        loop1: LOOP
            SET i = i + 1;
            SET genre = SPLIT_STR(in_genres, '|', i);

            IF genre = '' THEN
                LEAVE loop1;
            END IF;
            CALL get_top_movies(n, title_regexp, year_from, year_to, genre);
        END LOOP loop1;
    END IF;

END$$
DELIMITER ;

# CALL usp_find_top_rated_movies(10, NULL, 2000, NULL, 'Action|Drama');


# SELECT COALESCE(NULL, 1, NULL);