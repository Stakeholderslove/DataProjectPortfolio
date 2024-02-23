--Total Number of rows in the dataset

Select COUNT(*)
from Data1

Select COUNT(*)
from Data2

-- datasets from Jharkhand and Bihar
Select*  
From Data1
Where state in ('Jharkhand', 'Bihar')

-- Population of India

select SUM(Population) TotalPopulation
from Data2

-- Avg grwoth by State

Select state,AVG(Growth)*100 AvgGrowth
From Data1
Group by State


--Avg Sex ratio

select State, ROUND(Avg(Sex_ratio),0) Avg_Sex_Ratio
from Data1
Group by State
Order by Avg_Sex_Ratio Desc
Select*
from Data1

--Avg literacy ratio

select State, ROUND(Avg(literacy),0) Avg_literacy_ratio
from Data1
Group by State
Having ROUND(Avg(literacy),0) > 90
Order by Avg_literacy_ratio Desc


-- Top 3 State showing highest growth

Select Top 3 state, AVG(growth) Avg_growth_Rate
from Data1
Group by State
Order by Avg_growth_Rate

-- Bottom 3 state sex ratio

select top 3 state, ROUND(avg(sex_ratio),0) Avg_Sex_Ratio 
from Data1
group by State
order by Avg_Sex_Ratio


-- top and bottom 3 states in literacy state

Drop Table if exists #topstates
create table #topstates
( states nvarchar(255),
topsates float
)

insert into #topstates

Select State, ROUND(Avg(literacy),0) Avg_Literacy_ratio
from Data1
group by State
order by Avg_literacy_Ratio	

Select Top 3* from #topstates
order by #topstates.topsates Desc


Drop Table if exists #bottomstates
create table #bottomstates
( states nvarchar(255),
bottomstate float
)

insert into #bottomstates

Select State, ROUND(Avg(literacy),0) Avg_Literacy_ratio
from Data1
group by State
order by Avg_literacy_Ratio	desc

Select Top 3* from #bottomstates
order by #bottomstates.bottomstate asc

--Union Operator

 Select * from (
select Top 3* from #topstates
order by #topstates.topsates desc) a

union 
Select* from (
Select Top 3* from #bottomstates
order by #bottomstates.bottomstate asc) b

--State starting with letter A or B

Select distinct state
from Data1 
where state like 'a%' or state like 'b%'

--Joining table together
--Total Males and female 
Select *
from Data1

Select *
from Data2

Select d.state, sum(d.males) Total_males,sum(d.females) Total_females from 
(Select district, state, round(population/(Sex_Ratio+1),0) males, round((population*sex_ratio)/(Sex_Ratio+1),0) females  from 
(Select a.District, a.State,a.Sex_Ratio/1000 Sex_Ratio, b.Population
from Data1 a
inner join Data2 b
ON a.District = b.District) c ) d
group by d.state 

-- Total literacy rate
Select c.state, SUM(literate_people) Total_literate, SUM(illiterate_people) Total_illiterate from 
(Select d.District, d.State,round(d.Literacy*d.Population,0) literate_people,round((1-d.Literacy)*d.Population,0) illiterate_people from 
(Select a.District, a.State, a.Sex_Ratio, a.Literacy, b.Population
from Data1 a
inner join Data2 b
ON a.District = b.District) d)c
group by c.state


--Population in previous census
select g.total_area/g.previous_census_population  previous_census_population_vs_area,g.total_area/g.current_census_population  current_census_population_vs_area from
(Select q.*, r.total_area from(
Select '1' as keyy,n.* from
(Select  sum(m.previous_census_population) previous_census_population, sum(m.current_census_population) current_census_population from
(Select e.state, SUM(e.previous_census_population) previous_census_population, SUM(e.current_census_population) current_census_population from
(Select d.district, d.state, round(d.population/(1+d.growth),0) previous_census_population, d.population current_census_population from
(Select a.District, a.State,a.Growth growth, b.Population
from Data1 a
inner join Data2 b
ON a.District = b.District) d) e
group by e.State ) m) n) q inner join  (

Select '1'as keyy,z.* from (
Select SUM(area_km2) total_area from Data2) z) r on q.keyy = r.keyy ) g