-- Continental
Select continent, max(cast(total_deaths as int)) as TotalDeath
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by continent
order by TotalDeath desc

-- Continental Highest death count by population 

--Global numbers

Select date, sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases) as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
group by date
order by 1,2

--looking at total population and Vaccination
with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeoplevaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject.dbo.CovidDeaths dea
Join  PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp table

Drop table if exists #PercentPeopleVaccinated
Create Table #PercentPeopleVaccinated
(Continent nvarchar(50),
Location nvarchar(50),
Date datetime,
population numeric,
New_vaccinated numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPeopleVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeoplevaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject.dbo.CovidDeaths dea
Join  PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPeopleVaccinated


--Creating view to store data for later visualizations
Create view PercentPeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeoplevaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject.dbo.CovidDeaths dea
Join  PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * 
From PercentPeopleVaccinated