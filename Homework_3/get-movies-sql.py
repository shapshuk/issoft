import csv
import re
from mysql.connector import connect, Error
import mysql
from mysql.connector.connection import MySQLConnection
from python_mysql_dbconfig import read_db_config

RATINGS_PATH = "ml-latest-small/ratings.csv" 
MOVIES_PATH = "ml-latest-small/movies.csv"

class Movie:
    rating = 0
    ratings_sum = 0
    ratings_counter = 0

    # parsing movies.csv to movie objects
    def __init__(self, row):
        self.id = int(row[0])
        self.title = re.sub('\ \((\d*?)\)', '', row[1].replace('"', ''))
        self.genres = row[2]
        match = re.search('(?<=\()\d+?(?=\))', row[1])
        if match:
            self.year = int(match.group())
        else:
            self.year = 0


def movies_table_import(connection):
    with open(MOVIES_PATH, "r") as movies_f:
        movie_reader = csv.reader(movies_f)
        movie_dict = {}
        next(movie_reader, None)

        query = "INSERT INTO movies(id, title, ganres) " \
                "VALUES(%s, %s)"
        for row in movie_reader:
            movie = Movie(row)
            try: 
                db_config = read_db_config()
                conn = MySQLConnection(**db_config)
            args = (movie.id, movie.title, movie.genres)

        


if __name__ == "__main__":
    connection = None
    try:
        connection = mysql.connector.connect(host = 'localhost',
                                       database = 'movie_ratings_db',
                                       user = 'Admin',
                                       password = '')
        if connection.is_connected():
            print('Connected to MySQL database')



    except Error as e:
        print(e)
    finally:
        if connection is not None and connection.is_connected():
            connection.close()
