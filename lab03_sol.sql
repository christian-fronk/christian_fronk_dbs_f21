/*
  Lab 03: Creating tables and fields
  CSC 362 Database Systems
  Christian Fronk
*/

/* Create the database (dropping the previous version if necessary */
DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;

USE movie_ratings;


/* Create the tables */
CREATE TABLE movies (
    PRIMARY KEY (movie_id),
    movie_id         INT AUTO_INCREMENT,     
    movie_title        VARCHAR(180),
    release_date    DATE,
    genre          VARCHAR(50)
);

CREATE TABLE consumers (
    PRIMARY KEY (consumer_id),
    consumer_id   INT AUTO_INCREMENT,
    consumer_first_name   VARCHAR(50),
    consumer_last_name  VARCHAR(50),
    consumer_address     VARCHAR(50),
    consumer_city               VARCHAR(50),
    consumer_state     CHAR(2),
    consumer_zipcode              INT
);
/* Create the linking ratings table between consumers and movies */
CREATE TABLE ratings (
   PRIMARY KEY (movie_id, consumer_id),
  movie_id         INT,
  consumer_id      INT,
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id),
    when_rated DATETIME,
    number_stars INT
);

/* Populate the tables with sample data given
*/
INSERT INTO movies (movie_title, release_date, genre)
VALUES ('The Hunt For Red October','1990-03-02','Action,Adventure,Thriller'),
       ('Lady Bird','2017-12-01','Comedy,Drama'),
       ('Inception', '2010-0-16','Action,Adventure,Sci-Fi');

INSERT INTO consumers (consumer_first_name, consumer_last_name,consumer_address,consumer_city,consumer_state,consumer_zipcode)
VALUES ('Toru','Okada','800 Glenridge Ave','Hobart','IN','46342'),
       ('Kumiko','Okada','864 NW Bohemia St','Vincentown','NJ','08088'),
       ('Noboru','Wataya','342 Joy Ridge St','Hermitage','TN','37076'),
       ('May','Kasahara','5 Kent Rd','East Haven','CT','06512');


INSERT INTO ratings (movie_id,consumer_id,when_rated,number_stars)
VALUES ('1','1','2010-09-02 10:54:19','4'),
       ('1','3','2012-08-05 15:00:01','3'),
       ('1','4','2016-10-02 23:58:12','1'),
       ('2','3','2017-03-27 00:12:48','2'),
       ('2','4','2018-08-02 00:54:42','4');

       /* Generate a report */
SELECT consumer_first_name, consumer_last_name, movie_title, number_stars
  FROM movies
       NATURAL JOIN ratings
       NATURAL JOIN consumers;
       

/* Major problem is that genre is a multipart field, needs fixed*/

/* Step 6*/

DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;

USE movie_ratings;


/* Create the tables */
CREATE TABLE movies (
    PRIMARY KEY (movie_id),
    movie_id         INT AUTO_INCREMENT,     
    movie_title        VARCHAR(180),
    release_date    DATE
);

CREATE TABLE genres (
    PRIMARY KEY (genre_id),
    genre_id         INT AUTO_INCREMENT,     
    genre_type        VARCHAR(20)
);

CREATE TABLE movie_linking_genre (
  PRIMARY KEY (genre_id, movie_id),
  genre_id         INT,
  movie_id      INT,
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);


CREATE TABLE consumers (
    PRIMARY KEY (consumer_id),
    consumer_id   INT AUTO_INCREMENT,
    consumer_first_name   VARCHAR(50),
    consumer_last_name  VARCHAR(50),
    consumer_address     VARCHAR(50),
    consumer_city               VARCHAR(50),
    consumer_state     CHAR(2),
    consumer_zipcode              INT
);

CREATE TABLE ratings (
  PRIMARY KEY (movie_id, consumer_id),
  movie_id         INT,
  consumer_id      INT,
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id),
    when_rated DATETIME,
    number_stars INT
);

/* Populate the tables with sample data 
INSERT INTO authors (name_last, name_first, country)
VALUES ('Kafka', 'Franz', 'Czech Republic');
*/

/* Note: In the tutorial, there were two INSERT commands.  However,
   there is no need for that here, so I have just combined them into a
   single insertion with 4 values. */
INSERT INTO movies (movie_title, release_date)
VALUES ('The Hunt For Red October','1990-03-02'),
       ('Lady Bird','2017-12-01'),
       ('Inception', '2010-0-16');

INSERT INTO genres (genre_type)
VALUES ('Action'),
       ('Adventure'),
       ('Comedy'),
       ('Drama'),
       ('Sci-Fi'),
       ('Thriller');

INSERT INTO movie_linking_genre (movie_id,genre_id)
VALUES ('1','1'),
       ('1','2'),
       ('1','6'),
       ('2','3'),
       ('2','4'),
       ('3','1'),
       ('3','2'),
       ('3','5');
       

INSERT INTO consumers (consumer_first_name, consumer_last_name,consumer_address,consumer_city,consumer_state,consumer_zipcode)
VALUES ('Toru','Okada','800 Glenridge Ave','Hobart','IN','46342'),
       ('Kumiko','Okada','864 NW Bohemia St','Vincentown','NJ','08088'),
       ('Noboru','Wataya','342 Joy Ridge St','Hermitage','TN','37076'),
       ('May','Kasahara','5 Kent Rd','East Haven','CT','06512');


INSERT INTO ratings (movie_id,consumer_id,when_rated,number_stars)
VALUES ('1','1','2010-09-02 10:54:19','4'),
       ('1','3','2012-08-05 15:00:01','3'),
       ('1','4','2016-10-02 23:58:12','1'),
       ('2','3','2017-03-27 00:12:48','2'),
       ('2','4','2018-08-02 00:54:42','4');

       /* Generate a report */
SELECT consumer_first_name, consumer_last_name, movie_title, number_stars
  FROM movies
       NATURAL JOIN ratings
       NATURAL JOIN consumers;

SELECT movie_title,genre_type
FROM movies
    NATURAL JOIN movie_linking_genre
    NATURAL JOIN genres;

