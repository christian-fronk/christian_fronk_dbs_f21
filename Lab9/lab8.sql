-- WB: Good work Christian. Note that the procedure for trading pokemon, and the 
-- WB: trigger on trainer_party members actually conflict with each other. The procedure
-- WB: doesn't complete because the trigger prevents it.

DROP DATABASE IF EXISTS trade_pkmn;
CREATE DATABASE trade_pkmn;
USE trade_pkmn;

CREATE TABLE trainers (
    PRIMARY KEY  (trainer_id),
    trainer_id   INT(11) NOT NULL AUTO_INCREMENT,
    trainer_name VARCHAR(128) NOT NULL
);

CREATE TABLE pokemon_species (
    PRIMARY KEY  (species_name),
    species_name   VARCHAR(64) NOT NULL 
);

CREATE TABLE pokemon (
    PRIMARY KEY (pokemon_id),
    pokemon_id  INT(11) NOT NULL AUTO_INCREMENT,
    trainer_id  INT(11) NOT NULL,
    species_name VARCHAR(64) NOT NULL,
    FOREIGN KEY (trainer_id)
                REFERENCES trainers (trainer_id),
    FOREIGN KEY (species_name)
                REFERENCES pokemon_species (species_name)
);

CREATE TABLE trainer_party_members (
    PRIMARY KEY  (pokemon_id,trainer_id),
    pokemon_id  INT(11) NOT NULL,
    trainer_id  INT(11) NOT NULL,
    FOREIGN KEY (trainer_id)
                REFERENCES trainers (trainer_id),
    FOREIGN KEY (pokemon_id)
                REFERENCES pokemon (pokemon_id)
    
);





-- You man need to change the names of the tables and fields here to match your design.
INSERT INTO trainers (trainer_name)
VALUES ('Will'), -- Elite Four from Pokémon Gold/Silver/Crystal era.
       ('Koga'),
       ('Bruno'),
       ('Lance');

INSERT INTO pokemon_species (species_name)
VALUES ('Pikachu'),
       ('Charmander'),
       ('Bulbasuar'),
       ('Squirtle'),
       ('Geodude'),
       ('Magikarp'),
       ('Weedle'),
       ('Butterfree');

INSERT INTO pokemon (trainer_id, species_name) 
VALUES (1, 'Pikachu'),
       (1, 'Charmander'),
       (1, 'Bulbasuar'),
       (1, 'Squirtle'),
       (1, 'Geodude'),
       (1, 'Magikarp'),
       (1, 'Weedle'),
       (2, 'Pikachu'),
       (2, 'Charmander'),
       (2, 'Bulbasuar'),
       (2, 'Squirtle'),
       (2, 'Geodude'),
       (2, 'Magikarp'),
       (2, 'Weedle');

INSERT INTO trainer_party_members (pokemon_id, trainer_id)
VALUES (1, 1), -- Trade this one (Will's Pikachu)
       (2, 1),
       (3, 1),
       (4, 1),
       (5, 1),
       (6, 1),
       (11, 2); -- for this one. (Koga's Squirtle)


DROP FUNCTION IF EXISTS get_trainer_id;
DROP PROCEDURE IF EXISTS trade_pokemon;

CREATE FUNCTION get_trainer_id(poke_id INT(11)) RETURNS INT
RETURN (SELECT trainer_id
          FROM pokemon
         WHERE pokemon_id = poke_id);


DROP FUNCTION IF EXISTS trainer_party_size;

CREATE FUNCTION trainer_party_size(trainerid INT(11)) RETURNS INT
RETURN (SELECT COUNT(pokemon_id)
          FROM trainer_party_members
         WHERE trainer_id = trainerid);


DROP FUNCTION IF EXISTS total_pokemon;

CREATE FUNCTION total_pokemon(trainerid INT(11)) RETURNS INT
RETURN (SELECT COUNT(pokemon_id)
          FROM pokemon
         WHERE trainer_id = trainerid);


DROP FUNCTION IF EXISTS get_trainer_id_from_name;

CREATE FUNCTION get_trainer_id_from_name(trainername VARCHAR(128)) RETURNS INT
RETURN (SELECT trainer_id
          FROM trainers
         WHERE trainer_name = trainername);

DROP FUNCTION IF EXISTS get_starter_pokemon_id;

CREATE FUNCTION get_starter_pokemon_id(trainerid INT(11)) RETURNS INT
RETURN (SELECT pokemon_id
          FROM pokemon
         WHERE trainer_id = trainerid);


DELIMITER //

CREATE TRIGGER del_check_party_size
BEFORE DELETE ON trainer_party_members FOR EACH ROW 
IF trainer_party_size(OLD.trainer_id) <= 1 THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Can't have less than 1 pokemon";
END IF;
//


CREATE TRIGGER prevent_more_six_poke_table
BEFORE INSERT ON trainer_party_members FOR EACH ROW 
IF trainer_party_size(NEW.trainer_id) >= 6 THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Can't have more than 6 pokemon";
END IF;
//

CREATE TRIGGER check_party_size_update
BEFORE UPDATE ON trainer_party_members FOR EACH ROW 
IF NEW.trainer_id != OLD.trainer_id THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Can't perform this update!";
END IF;
//



/* Create a function to trade pokemon between 2 trainers*/
CREATE PROCEDURE trade_pokemon(IN pokemon1 INT(11), IN pokemon2 INT(11))
BEGIN
    START TRANSACTION;

        SET @pokemon1_trainer = (get_trainer_id(pokemon1));
        SET @pokemon2_trainer = (get_trainer_id(pokemon2));

        UPDATE trainer_party_members
           SET trainer_id = @pokemon1_trainer
         WHERE pokemon_id = pokemon2;

        UPDATE trainer_party_members
           SET trainer_id = @pokemon2_trainer
         WHERE pokemon_id = pokemon1;
    COMMIT;
END //


CREATE PROCEDURE delete_from_db(IN trainerid INT(11))
BEGIN
SET FOREIGN_KEY_CHECKS=0;
    START TRANSACTION;
    DELETE FROM trainers WHERE trainer_id = trainerid;
    DELETE FROM pokemon WHERE trainer_id = trainerid;
    DELETE FROM trainer_party_members WHERE trainer_id = trainerid;
    
    /*
    SET @total_num_pokemon = (total_pokemon(trainerid));
    IF @total_num_pokemon < 1 THEN 
    DELETE FROM trainers WHERE trainer_id = trainerid;
END IF;
*/
    COMMIT;
    SET FOREIGN_KEY_CHECKS=1;
END //


CREATE PROCEDURE insert_into_db(IN trainername VARCHAR(128), IN pokemonspecies VARCHAR(64))
BEGIN
    START TRANSACTION;
        INSERT INTO trainers (trainer_name)
        VALUES (trainername);

       SET @trainerid = (get_trainer_id_from_name(trainername));

        INSERT INTO pokemon (trainer_id, species_name)
        VALUES (@trainerid,pokemonspecies);

        SET @starterid = (get_starter_pokemon_id(@trainerid));

        INSERT INTO trainer_party_members (pokemon_id, trainer_id)
        VALUES (@starterid,@trainerid);
    COMMIT;
END //


DELIMITER ;

/* Let's show off our work 
      SELECT pokemon_id, trainer_name
        FROM trainers
NATURAL JOIN pokemon;

*/

SELECT * FROM trainer_party_members;

/* Trade poke1 and poke2 */
CALL trade_pokemon("1", "11");

/* Show the results again 
      SELECT pokemon_id, trainer_name
        FROM trainers
NATURAL JOIN pokemon;*/
SELECT * FROM trainer_party_members;

/* Adding a new Pokemon just for testing purposes */
INSERT INTO pokemon (trainer_id, species_name) 
VALUES (1, 'Pikachu');

/* Try to insert into Will's party, won't work due to trigger*/
INSERT INTO trainer_party_members (pokemon_id, trainer_id)
VALUES (15, 1);


/* Let's give Bruno a Pokemon*/
INSERT INTO pokemon (trainer_id, species_name) 
VALUES (3, 'Weedle');

/* Now let's put it in his party*/
INSERT INTO trainer_party_members (pokemon_id, trainer_id)
VALUES (16, 3);

/* Try to delete it, won't work due to trigger*/
DELETE FROM trainer_party_members WHERE pokemon_id = 16;

/* Check update trigger*/
UPDATE trainer_party_members SET trainer_id = 1 WHERE pokemon_id = 16;

/*But it will not delete Will, who has Pokemon associated with him*/
SELECT * FROM trainers;
SELECT * FROM pokemon;
SELECT * FROM trainer_party_members;
CALL delete_from_db(1);
SELECT * FROM trainers;
SELECT * FROM pokemon;
SELECT * FROM trainer_party_members;

/*Call procedure to add a new trainer, and make sure they have a starter Pokemon, and make sure it's in their party*/
CALL insert_into_db("Jeff","Squirtle");

SELECT * FROM trainers;

SELECT * FROM trainer_party_members;






