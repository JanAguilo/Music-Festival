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
	SELECT 
		vendor.name, 
		ticket.type
	FROM 
		vendor
	JOIN 
		ticket ON vendor.id_vendor = ticket.id_vendor
	JOIN 
		festival ON ticket.festival_name = festival.name
	JOIN 
		festivalgoer ON ticket.id_festivalgoer = festivalgoer.id_festivalgoer
	JOIN 
		person ON festivalgoer.id_festivalgoer = person.id_person
	WHERE 
		person.name = 'Jan'
	AND 
		person.surname = 'Laporta'
	AND 
		festival.edition = 2018
	AND 
		festival.name = "Primavera Sound";
        
        
-- Query 4: 
-- For each festival, calculate how many different editions they have had. Build a list with
-- festival_name and the count of editions. Sort the result by the number of editions descending.
	SELECT 
		DISTINCT `name`, COUNT(*) AS num_of_editions
	FROM
		festival
	GROUP BY
		`name`
	ORDER BY num_of_editions DESC;

-- Query 5:
-- Which is the music festival which sold the biggest amount of tickets? How many tickets have they sold?
	SELECT 
		festival.`name` AS festival_with_most_tickets_sold, 
        COUNT(*) AS tickets_sold
    FROM 
		ticket
    JOIN 
		festival ON ticket.festival_name = festival.`name`
    GROUP BY 
		festival.`name`
    ORDER BY 
		tickets_sold DESC
    LIMIT 1;
    
-- EXTRA: For each music festival name, provide the evolution in sellings year after year. Sort
-- the result for festival name and edition ascending.
	SELECT 
		festival.`name` AS festival_name, 
        festival.edition AS festival_edition, 
        COUNT(*) AS tickets_sold
    FROM 
		ticket
    JOIN 
		festival ON ticket.festival_name = festival.`name` 
				 AND ticket.festival_edition = festival.edition
    GROUP BY 
		festival.`name`, festival.edition
    ORDER BY 
		festival.`name`, festival.edition ASC;
        
-- Query 6: 
-- Get a list of all the different preferred instruments and the count of how many musicians
-- play each instrument. Sort the result descending by the number of musicians playing each instrument.
	SELECT 
		prefered_instrument, 
        COUNT(*) AS num_of_musicians
	FROM
		artist
	GROUP BY 
		prefered_instrument
	ORDER BY 
		num_of_musicians DESC;
        
-- Query 7:
-- We want to audit the staff contracts. Is there any contract for less than 2 years? Please
-- identify the staff members with a short contract and provide a list with their id, names,
-- surnames, nationality, birthdate and the duration of their contract in days ordered by this
-- last one in ascending order to know which one had the shortest contract.
	SELECT
		staff.id_staff,
		person.`name`,
		person.surname,
		person.nationality,
		person.birth_date,
		DATEDIFF(staff.contract_expiration_date, staff.hire_date) AS contract_duration
	FROM 	
		staff
	JOIN 
		person ON staff.id_staff = person.id_person
	WHERE 
		DATEDIFF(staff.contract_expiration_date, staff.hire_date) < (2 * 365)
	ORDER BY
		contract_duration ASC;

-- EXTRA: Can you also add in the list the information of what kind of worker is each one?
-- ("beerman", "bartender", "security" or "community_manager"). Use SQL CASE expression.
	SELECT
		staff.id_staff,
		person.`name`,
		person.surname,
		person.nationality,
		person.birth_date,
		DATEDIFF(staff.contract_expiration_date, staff.hire_date) AS contract_duration,
        CASE
			WHEN beerman.id_beerman THEN 'beerman'
            WHEN bartender.id_bartender THEN 'bartender'
            WHEN `security`.id_security THEN 'security'
            WHEN community_manager.id_community_manager THEN 'community_manager'
            ELSE 'Unknown'
		END AS worker_type
	FROM 	
		staff
	JOIN 
		person ON staff.id_staff = person.id_person
	LEFT JOIN
		beerman ON staff.id_staff = beerman.id_beerman
	LEFT JOIN
		bartender ON staff.id_staff = bartender.id_bartender
	LEFT JOIN
		`security` ON staff.id_staff = `security`.id_security
	LEFT JOIN 
		community_manager ON staff.id_staff = community_manager.id_community_manager
	WHERE 
		DATEDIFF(staff.contract_expiration_date, staff.hire_date) < (2 * 365)
	ORDER BY
		contract_duration ASC;

-- Query 8: 
-- Show the name, surname, nationality and birthdate of all the artists of Coldplay. Is there
-- more than one Coldplay band in the world? If so, add the country of the band in the result.
	SELECT 
		person.`name`,
        person.surname,
        person.nationality,
        person.birth_date,
        artist.band_country
	FROM
		person
	JOIN
		artist ON person.id_person = artist.id_artist
	JOIN
		band ON artist.band_name = band.`name` AND artist.band_country = band.country
	WHERE
		artist.band_name = 'Coldplay';

-- Query 9: 
-- Get a unique list (without repeated data) with name and description of all the non-alcoholic
-- drinks provided by 'Spirits Source'.
	SELECT DISTINCT
		product.`name`, 
        product.`description`
	FROM 
		beverage
	JOIN
		product ON beverage.id_beverage = product.id_product
	JOIN
		bar_product ON bar_product.id_product = product.id_product
	JOIN
		product_provider_bar ON product_provider_bar.id_bar = bar_product.id_bar 
							AND product_provider_bar.id_product = bar_product.id_product
	JOIN
		provider ON product_provider_bar.id_provider = provider.id_provider
	WHERE
		provider.`name` = 'Spirits Source'
        AND beverage.is_alcoholic = 0;
        
-- Query 10:
-- As festival organisers, we are in trouble because there were some youngsters drinking
-- alcohol. Get a list of their names, surnames, nationality and birth date for the festivalgoers
-- who had been drinking being under 18 years of age.
    


-- EXTRA: Include their friends in that list in order to contact their family too.
        
		
        
	
		
    


	






