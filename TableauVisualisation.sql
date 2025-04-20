/*

Queries used for Tableau Project

*/

USE PortfolioProjects;

-- 1. 

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS SIGNED)) 
AS total_deaths, SUM(CAST(new_deaths AS SIGNED))/SUM(New_Cases)*100 AS DeathPercentage
From PortfolioProjects.coviddeaths
-- Where location like '%states%'
WHERE continent IS NOT NULL 
-- GROUP BY date
ORDER BY 1,2;

-- 2. 

SELECT continent, SUM(CAST(new_deaths AS SIGNED)) AS TotalDeathCount
From PortfolioProjects.coviddeaths
-- Where location like '%states%'
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- 3.

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  
Max((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProjects.coviddeaths
-- Where location like '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- 4.

SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount,
Max((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProjects.coviddeaths
-- Where location like '%states%'
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;