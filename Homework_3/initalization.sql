CREATE DATABASE IF NOT EXISTS movie_ratings_db;

USE movie_ratings_db;

DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS movies;

CREATE TABLE movies

(
    movieId INT PRIMARY KEY,
    title VARCHAR(500),
    genres VARCHAR(100)
);

CREATE TABLE ratings
(
    userId INT,
    movieId INT,
    rating FLOAT,
    `timestamp` INT,
#     CONSTRAINT fk_movies_movieId FOREIGN KEY (movieId) REFERENCES movies (movieId)
    FOREIGN KEY  (movieId) REFERENCES movies(movieId)
);


# drop table ratings;
# SHOW VARIABLES LIKE 'secure_file_priv';
# F:\Work\Python\ISSoft\Homework_3\csv_src
# LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/csv_src/movies.csv'
LOAD DATA INFILE '/var/lib/mysql-files/movies.csv'
INTO TABLE movies
CHARACTER SET UTF8
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/ratings.csv'
INTO TABLE ratings
CHARACTER SET UTF8
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

# SELECT title, genres FROM movies WHERE movieId = 1;

# SELECT movies.title, movies.movieId, rating
# FROM movies, ratings
# LIMIT 0, 10;


# input_genres
# input_year
# input_title_regex
# input_movie_count


# SELECT title, avg(rating) as avg_rating, genres
# FROM movies
# JOIN ratings r on movies.movieId = r.movieId
#
# WHERE
#     (movies.genres LIKE '%Drama%')
#     AND (movies.title LIKE '%(1999)')
#     AND (movies.title REGEXP 'T')
#
#
# group by movies.movieId, title, genres
# order by avg_rating desc;
# LIMIT 0, 10;


