--CREATE TABLE CALLED country_vaccinations
CREATE TABLE country_vaccinations(
	country VARCHAR(255),
	iso_code VARCHAR(255),
	date_time DATE,	
	total_vaccinations FLOAT,	
	people_vaccinated FLOAT,
	people_fully_vaccinated	FLOAT,
	daily_vaccinations_raw FLOAT,
	daily_vaccinations FLOAT,
	total_vaccinations_per_hundred FLOAT,
	people_vaccinated_per_hundred FLOAT,
	people_fully_vaccinated_per_hundred	FLOAT,
	daily_vaccinations_per_million FLOAT,
	vaccines VARCHAR(255),
	source_name	VARCHAR(255),
	source_website VARCHAR(255)
);



--QUERY ALL FIELDS FROM TABLE
select * from country_vaccinations









------------------------------
--CREATE TABLE CALLED country_vac_manuf
CREATE TABLE country_vac_manuf(
	country VARCHAR(255),
	date_time DATE,
	vaccine VARCHAR(255),
	total_vaccinations FLOAT
);






--query all fields from table
SELECT * FROM country_vac_manuf




----Covid-19 Data Exploration
----Skills used: Joins, Temp Tables, Windows functions, CTE, Aggregate Functions, Creating Views, Converting Data Types

SELECT * FROM country_vac_manuf
SELECT * FROM country_vaccinations




-- Select Data that we are going to be starting with
SELECT country, iso_code, date_time, total_vaccinations, vaccines FROM country_vaccinations
WHERE total_vaccinations>0
ORDER BY  total_vaccinations ASC




----------------------------------
--show table without null, remove null values,use CREATE VIEW function to add new table
SELECT * FROM country_vaccinations
WHERE country_vaccinations IS NOT NULL

----------------------------------
CREATE VIEW COUNTRY_VAC_UPDATE AS
SELECT * FROM country_vaccinations
WHERE country_vaccinations IS NOT NULL





-------------------------------------
-- Total VACCINATIONS PER COUNTRY 
select country, sum(total_vaccinations) as "total_of_vaccine" from country_vaccinations
group by country
order by total_of_vaccine






-------------------------------
-- PEOPLE FULLY VACCINATED PER COUNTRY(use view table) per day
SELECT * FROM COUNTRY_VAC_UPDATE
-------------------------------
SELECT country, date_time, sum(people_fully_vaccinated) as "peop_total_fully_vac" from COUNTRY_VAC_UPDATE
group by country, date_time
order by date_time asc



	
-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2






-- Showing WHICH VACCINE WAS USED THE MOST BY EACH COUNTRY 


--MOSTLY USED VACCINE IN THE WORLD
select country, vaccine, sum(total_vaccinations) as "sum_of_vaccinations" from country_vac_manuf
group by country, vaccine
order by sum_of_vaccinations desc




------filter down by country and remove european union
select country, vaccine, sum(total_vaccinations) as "sum_of_vaccinations" from country_vac_manuf
group by country, vaccine
having country <> 'European Union'
order by sum_of_vaccinations desc 





-- create view table for mostly used vaccine in the world
CREATE VIEW WORLD_VACCINE AS 
SELECT country, vaccine, SUM(total_vaccinations) AS "sum_of_vaccinations" FROM country_vac_manuf
GROUP BY country, vaccine
ORDER BY sum_of_vaccinations DESC






--query all tables from both tables
SELECT * FROM country_vac_manuf
SELECT * FROM COUNTRY_VAC_UPDATE





---------------------------------------
--query max total_vacc by country
--looking at highest total_vaccine per country and used vaccines in each country 
select country, vaccines, max(total_vaccinations) as "max_vaccination" from COUNTRY_VAC_UPDATE
group by country, vaccines
order by max_vaccination desc




---------------------------------------
--connect two tables using join function
select vac_update.country, vac_update.date_time, vac_update.people_fully_vaccinated, vac_update.total_vaccinations,
vac_manuf.vaccine from COUNTRY_VAC_UPDATE as vac_update
join country_vac_manuf as vac_manuf on vac_update.country = vac_manuf.country
order by vac_update.country






---------------------------------------
--TOTAL VACCINATIONS vs PEOPLE FULLY VACCINATED in United States
--calculates percentage of fully vaccinated people per day, filtered by United States

SELECT * FROM COUNTRY_VAC_UPDATE


SELECT country, date_time, people_fully_vaccinated,  total_vaccinations,
round(CAST (people_fully_vaccinated/total_vaccinations*100 AS NUMERIC),2) AS "fully_vaccin_pcnt"
FROM COUNTRY_VAC_UPDATE
WHERE country LIKE '%States%'
ORDER BY fully_vaccin_pcnt ASC;





---------------------------------------
---use CTE function to reference temporary result set.
--useful for breaking down complex queries into readable parts
WITH country_vac_cte as (
	SELECT country, total_vaccinations, people_fully_vaccinated_per_hundred, vaccines
	FROM COUNTRY_VAC_UPDATE
)
SELECT country, total_vaccinations, people_fully_vaccinated_per_hundred, vaccines
FROM country_vac_cte
ORDER BY country



