use PortfolioProjects;
SELECT * FROM coviddeaths;
SELECT * FROM coviddeaths ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2;

-- Total Cases vs Total Deaths

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM coviddeaths
WHERE location like '%Africa%'
ORDER BY 1,2;

-- Total cases vs Population

SELECT location, date, total_cases,population, (total_cases/population)*100 AS population_infected_percentage
FROM coviddeaths
WHERE location like '%Africa%'
ORDER BY 1,2;

-- Countries with Highest Infection Rate compared to population

SELECT location, population, 
MAX(total_cases) AS Highest_Infection_Count, 
MAX((total_cases/population))*100 AS population_infected_percentage
FROM coviddeaths
GROUP BY location, population
ORDER BY population_infected_percentage DESC;

-- Countries with the Highest Death Count per population

SELECT location, MAX(total_deaths) AS total_death_count
FROM coviddeaths GROUP BY location
ORDER BY total_death_count DESC;

SELECT * FROM coviddeaths WHERE continent is not NULL ORDER BY 3,4;

SELECT location, MAX(CAST(total_deaths AS SIGNED)) AS total_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- Continent
-- Content with highest death count

SELECT continent, MAX(CAST(total_deaths AS SIGNED)) AS total_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Worldwide Numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS SIGNED)) AS total_deaths,
SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 AS death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

SELECT  SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS SIGNED)) AS total_deaths,
SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 AS death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- Total Population vs Vaccinations

SELECT * FROM PortfolioProjects.covidvaccinations;

SELECT *
FROM PortfolioProjects.coviddeaths dea 
JOIN PortfolioProjects.covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProjects.coviddeaths dea 
JOIN PortfolioProjects.covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.location)
FROM PortfolioProjects.coviddeaths dea 
JOIN PortfolioProjects.covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(vac.new_vaccinations, SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS rolling_people_vaccinated
-- ,(rolling_people_vaccinated/population)*100
FROM PortfolioProjects.coviddeaths dea 
JOIN PortfolioProjects.covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (continent, location, date, population, new_Vaccinations, rolling_people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, SIGNED)) OVER (PARTITION BY dea.Location Order by dea.location, dea.Date) AS rolling_people_vaccinated
-- ,(rolling_people_vaccinated/population)*100
From PortfolioProjects.covidDeaths dea
Join PortfolioProjects.covidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent IS NOT NULL 
-- order by 2,3
)
Select *, (rolling_people_vaccinated/population)*100
From PopvsVac;


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS percentpopulationvaccinated;

CREATE TABLE percentpopulationvaccinated (
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
);


INSERT INTO percentpopulationvaccinated
SELECT 
   dea.continent, dea.location, 
STR_TO_DATE(dea.date,'%d/%m/%Y')AS date,
   dea.population,COALESCE(vac.new_vaccinations, 0),
 SUM(
    CASE WHEN vac.new_vaccinations IS NULL OR vac.new_vaccinations = '' THEN 0 ELSE 
 CONVERT(REPLACE(vac.new_vaccinations, ',', ''), SIGNED) END)
	 OVER (PARTITION BY dea.location Order by dea.location, STR_TO_DATE(dea.date,'%d/%m/%Y')) AS rolling_people_vaccinated
FROM 
  (SELECT *, STR_TO_DATE(date,'%d/%m/%Y') AS parsed_date FROM PortfolioProjects.coviddeaths
) dea
JOIN (
    SELECT *, STR_TO_DATE(date,'%d/%m/%Y') AS parsed_date FROM PortfolioProjects.covidvaccinations
) vac
	ON dea.location = vac.location
	AND dea.parsed_date = vac.parsed_date
WHERE dea.continent IS NOT NULL;
-- order by 2,3

Select *, (rolling_people_vaccinated/population)*100
From percentpopulationvaccinated;

-- Creating View to store data for later visualizations

CREATE VIEW percentpopulationvaccinated_view AS
SELECT 
  d.continent,
  d.location,
  STR_TO_DATE(d.date, '%d/%m/%Y') AS date,
  d.population,
  COALESCE(v.new_vaccinations, 0) AS new_vaccinations,
  SUM(
    CASE 
      WHEN v.new_vaccinations IS NULL OR v.new_vaccinations = '' THEN 0
      ELSE CONVERT(REPLACE(v.new_vaccinations, ',', ''), SIGNED)
    END
  ) OVER (
    PARTITION BY d.location 
    ORDER BY d.location, STR_TO_DATE(d.date, '%d/%m/%Y')
  ) AS rolling_people_vaccinated
FROM PortfolioProjects.coviddeaths d
JOIN PortfolioProjects.covidvaccinations v
  ON d.location = v.location
  AND STR_TO_DATE(d.date, '%d/%m/%Y') = STR_TO_DATE(v.date, '%d/%m/%Y')
WHERE d.continent IS NOT NULL;
