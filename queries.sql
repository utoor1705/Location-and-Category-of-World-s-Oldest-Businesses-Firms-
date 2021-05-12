/* Objective: Determine the Location & Category of World's Oldest Businesses & Firms */
/* Considering the three datasets we have, we will utilize each one at appropriate times, these include business.csv, categories.csv & countries.csv */

/* Step 1: To create database which could be utilized by our queries */

CREATE TABLE categories (
  category_code VARCHAR(5) PRIMARY KEY,
  category VARCHAR(50)
);

\copy categories FROM 'categories.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE countries (
  country_code CHAR(3) PRIMARY KEY,
  country VARCHAR(50),
  continent VARCHAR(20)
);

\copy countries FROM 'countries.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE businesses (
  business VARCHAR(64) PRIMARY KEY,
  year_founded INT,
  category_code VARCHAR(5),
  country_code CHAR(3)
);

\copy businesses FROM 'businesses.csv' DELIMITER ',' CSV HEADER;


/* Now, we can work on quries to obtain our resutls */ 


/* Select the oldest and newest founding years from the businesses table */

SELECT MAX(year_founded) AS newest, MIN(year_founded) AS oldest 
FROM businesses

/* Get the count of rows in businesses where the founding year was before 1000 */

SELECT COUNT(1)
FROM businesses
WHERE year_founded < 1000

/* Select all columns from businesses where the founding year was before 1000, and arranging them from oldes to newest, this will give us the oldest functioning busienss - Kongō Gumi - and its location*/

SELECT *
FROM businesses
WHERE year_founded < 1000
ORDER BY year_founded


/* Select business name, founding year, and country code from businesses; and category from categories. Moreover, where the founding year was before 1000, arranged from oldest to newest. This will give us its category. */

SELECT b.business, b.year_founded, b.country_code, c.category
FROM businesses b
JOIN categories c ON c.category_code = b.category_code
WHERE b.year_founded < 1000
ORDER BY b.year_founded


/* Select the category and count of category (as "n"), arranged by descending count, limited to 10 most common categories. This will give us the category which has the most count value, in all older businesses. */

SELECT c.category, COUNT(1) AS n
FROM categories c
JOIN businesses b ON c.category_code = b.category_code
GROUP BY c.category
ORDER BY COUNT(1) DESC
LIMIT 10

/* Select the oldest founding year (as "oldest") from businesses, and continent from countries, for each continent, ordered from oldest to newest. This will give us the continent with the most oldest businesses. */

SELECT MIN(b.year_founded) AS oldest, c.continent
FROM countries c
JOIN businesses b ON c.country_code = b.country_code
GROUP BY c.continent
ORDER BY MIN(b.year_founded)


/* Combine all three tables for further analysis. An example givien below */

WITH whole_table as (SELECT * FROM 
	(SELECT * 
	FROM businesses JOIN countries
	ON businesses.country_code = countries.country_code) AS intermediate
	JOIN categories ON categories.category_code = intermediate.category_code) 

SELECT continent, COUNT(*) as c 
FROM whole_table
GROUP BY continent
HAVING c > 5
ORDER BY c DESC


