SET NAMES 'utf8mb4'; -- UTF 8

USE P101_06_challange2_music_festival;
-- non-spicy and veggie friendly food options including rice
DROP VIEW IF EXISTS query_01;
CREATE VIEW query_01 AS
	SELECT product.name, product.description
		FROM food
		JOIN product ON food.id_food = product.id_product
		WHERE food.is_veggie_friendly = true
		AND food.is_spicy = false;

-- How many security guards use guns and how many use martial arts?
-- Retrieve a result set with two columns.
DROP VIEW IF EXISTS query_02;
CREATE VIEW query_02 AS
	SELECT
		COUNT(CASE WHEN knows_martial_arts=true THEN 1 END) AS martial_arts,
		COUNT(CASE WHEN is_armed=true THEN 1 END) AS guns
		FROM `security`;
        
-- EXTRA: Can you include the information for each festival name?
DROP VIEW IF EXISTS query_02_extra;
CREATE VIEW query_02_extra AS
	SELECT
		festival_name,
		COUNT(CASE WHEN knows_martial_arts=true THEN 1 END) AS martial_arts,
		COUNT(CASE WHEN is_armed=true THEN 1 END) AS guns
	FROM `security`
    GROUP BY festival_name;

-- QUERY 3:Find the name of the ticket vendor where Jan Laporta
-- got his ticket for Primavera Sound of  2018.
-- Which type of ticket was it?
	SELECT vendor.name, ticket.type
		FROM vendor
        JOIN ticket ON vendor.id_vendor = ticket.id_vendor
        JOIN festival ON ticket.festival_name = festival.name
        JOIN festivalgoer ON ticket.id_festivalgoer = festivalgoer.id_festivalgoer
        JOIN person ON festivalgoer.id_festivalgoer = person.id_person
        WHERE person.name = 'Jan'
        AND person.surname = 'Laporta'
        AND festival.edition = 2018
        AND festival.name = "Primavera Sound";
