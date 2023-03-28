--Data source https://ourworldindata.org/covid-deaths 

create database SQLPortfolio

use SQLPortfolio


-- Exploring data 
Select Location, date, total_cases, new_cases, total_deaths, population 
from SQLPortfolio..CovidDeaths 
order by 1,2

-- Looking at Total Cases vs Total Deaths 
-- Shows the likelihood of dying if you contact covid in Costa Rica 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from SQLPortfolio..CovidDeaths 
where location like '%costa rica%'
order by 1,2

-- Looking at the total cases  vs Population 
-- Shows what percentage of population got covid in Costa Rica
Select Location, date, total_cases, population, (total_cases/population)*100 as Infected_Population_Percentage_CostaRica
from SQLPortfolio..CovidDeaths 
where location like '%costa rica%'
order by Infected_Population_Percentage_CostaRica desc

-- Shows what percentage of population got covid in all countries 
Select Location, date, total_cases, population, (total_cases/population)*100 as Infected_Population_Percentage_Global
from SQLPortfolio..CovidDeaths 
-- where location like '%costa rica%'
order by Infected_Population_Percentage_Global desc

-- Looking at Countries with Highest infection rate compared to population 
Select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from SQLPortfolio..CovidDeaths 
--where location like '%costa rica%'
group by Location, population
order by PercentPopulationInfected desc

-- Showing the continents with highest death count per population
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from SQLPortfolio..CovidDeaths 
--where location like '%costa rica%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Showing the countries with Highest Death Count per Population 
Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from SQLPortfolio..CovidDeaths 
--where location like '%costa rica%'
where continent is not null
group by Location
order by TotalDeathCount desc

-- Global numbers by date

Select date
, sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths
, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from SQLPortfolio..CovidDeaths 
where continent is not null
group by date
order by 1,2


---Looking at total population vs vaccinations 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.Location Order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
from SQLPortfolio..CovidDeaths dea
Join SQLPortfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--- Checking amount of vaccinated people by location ordered by date  using CTE

With PopvsVac (continent, location, date, population, new_vaccinations ,PeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.Location Order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
from SQLPortfolio..CovidDeaths dea
Join SQLPortfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (PeopleVaccinated/population)*100
from PopvsVac



-- Checking the percentage a of vaccinated people by location ordered by date using TEMP TABLE 

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric,
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.Location Order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
from SQLPortfolio..CovidDeaths dea
Join SQLPortfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (PeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--- creating view to store data for later visualizations 

create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.Location Order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
from SQLPortfolio..CovidDeaths dea
Join SQLPortfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
