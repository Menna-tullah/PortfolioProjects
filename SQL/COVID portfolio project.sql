SELECT *
FROM [portfolio project]..CovidDeaths
WHERE continent is not null
ORDER BY 3, 4



SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [portfolio project]..CovidDeaths
ORDER BY 1,2 


-- looking at total cases vs total deaths	

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPrecenetage
FROM [portfolio project]..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2 


-- looking at total cases vs population
SELECT location, date, total_cases, population, (total_cases/population)*100 AS casesPrecenetage
FROM [portfolio project]..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2 


-- looking at countries with highest infection rate compared to population
SELECT location, Population, MAX(total_cases) AS HeighestInfectionCount, MAX((total_cases/population)*100) AS MAXcasesPrecenetage
FROM [portfolio project]..CovidDeaths
GROUP BY location, Population
ORDER BY 1,2 desc



-- showing countries with highest death count per population
SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM [portfolio project]..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc


-- showing continent with highest death count per population
SELECT continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM [portfolio project]..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


-- Global numbers
SELECT SUM(new_cases) AS totalCases, SUM(CAST(new_deaths AS int)) AS totalDeath, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS deathPrecentage
FROM [portfolio project]..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2


SELECT * 
FROM [portfolio project]..CovidVaccinations


-- looking at total population vs total vaccinations
-- use CTE
WITH Popvsvac(continent, location, date, population, new_vaccinations, rollingPeopleVaccinated)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) AS rollingPeopleVaccinated
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
	ON dea.date = vac.date
	AND dea.location = vac.location
WHERE dea.continent is not null
)
SELECT *, (rollingPeopleVaccinated/population)*100
FROM Popvsvac


-- create view to store data for visualizations
CREATE VIEW PerenetagePopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) AS rollingPeopleVaccinated
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
	ON dea.date = vac.date
	AND dea.location = vac.location
WHERE dea.continent is not null


SELECT * 
FROM PerenetagePopulationVaccinated

