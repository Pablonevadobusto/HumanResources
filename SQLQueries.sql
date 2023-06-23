/** CREATING THE DATABASE **/

CREATE DATABASE HiltopGroup;

-- Adding and updating a new column 

 ALTER TABLE HumanResources 
 ADD Age int


UPDATE HumanResources
SET Age = DateDiff(YEAR,birthdate,GETDATE())

-- Checking the data in Age

SELECT MIN(Age) as minAge
		,MAX(AGE) as maxAge
From HumanResources

-- What is the AGE distribution of employees in the company?

-- AVG Age

SELECT avg(Age) as AVGAge
FROM HumanResources


SELECT CASE WHEN age >= 21and Age <=39 THEN 'junior'
		ELSE 'senior'
		END as Bins
		,gender
		,COUNT(*) as count
FROM HumanResources
group by CASE WHEN age >= 21and Age <=39 THEN 'junior'
		ELSE 'senior'
		END
		,gender
ORDER BY Bins

select FLOOR(age/10)*10 as ageGroup
		,COUNT(*)
FROM HumanResources
group by FLOOR(age/10)
order by ageGroup



-- Checking % employees are currently in the company
SELECT 100.0* (
SELECT COUNT(*) 
FROM HumanResources
WHERE termdate >= CAST(Getdate() as date) OR termdate is NULL)/COUNT(*) 
FROM HumanResources


-- What is the average length of employment for employees who have been terminated?

select ROUND(1.0*AVG(DATEDIFF(year, hire_date, termdate)),2) as AvgEmployeeTime
FROM HumanResources
where termdate < CAST(Getdate() as date)

select *
FROM HumanResources
where termdate < CAST(Getdate() as date)

-- Checking how many employees are under age

SELECT COUNT(*)
FROM HumanResources
WHERE age < 18

-- % of employees work remotely
-- How many employees work at headquarters vs remote LOCATIONS?
SELECT distinct location 
from HumanResources

select ROUND(100.0 * (
SELECT COUNT(*)
FROM HumanResources
WHERE location = 'Remote') / COUNT(*) ,2)
FROM HumanResources


SELECT location	
		,COUNT(*) as count
FROM HumanResources
group by location


-- What is the GENDER breakdown of employees in the company?
SELECT distinct gender 
from HumanResources

SELECT gender	
		,COUNT(*) as count
FROM HumanResources
group by gender

SELECT gender	
		,100.0 * COUNT(*) / SUM(COUNT(*)) OVER()
FROM HumanResources
group by gender

-- How does the GENDER distribution vary across departments?


SELECT gender
		,department
		,COUNT(*) as count
FROM HumanResources
group by gender
		,department
ORDER BY gender
		,department

-- What is the RACE breadown of employees in the company?
SELECT distinct race 
from HumanResources
order by race

SELECT race	
		,COUNT(*) as count
FROM HumanResources
group by race
order by count desc;

-- JOBTITLE
SELECT distinct jobtitle 
from HumanResources
order by jobtitle

SELECT jobtitle	
		,COUNT(*) as count
FROM HumanResources
group by jobtitle
ORDER BY count desc

-- Which DEPARTMENT has the highest Turnover?

SELECT distinct department 
from HumanResources
order by department

select department
		,COUNT(*) as TotalCount
		,SUM(CASE WHEN termdate <= CAST(getdate() as date) THEN 1 else 0 END) as FormerEmployees
		,SUM(CASE WHEN termdate <= CAST(getdate() as date) THEN 1 else 0 END)*1.0/ COUNT(*)*1.0 as TerminationRate
FROM HumanResources
group by department
ORDER BY TerminationRate DESC

-- What is the distribution of employees across locations by state?

SELECT location_state
		,COUNT(*) as Count
from HumanResources
GROUP BY location_state
order by Count desc

-- How has the company's employee count changed over time based on hire and termination Dates?

select YEAR(hire_date) as Year
		,COUNT(*) as hires
		,SUM(CASE WHEN termdate <= CAST(Getdate() as date) THEN 1 ELSE 0 END) as Terminations
		,COUNT(*) - SUM(CASE WHEN termdate <= CAST(Getdate() as date) THEN 1 ELSE 0 END) as NetEmployees
		,ROUND(100.0*(COUNT(*) - SUM(CASE WHEN termdate <= CAST(Getdate() as date) THEN 1 ELSE 0 END))/ COUNT(*), 2) as NetEmployeesPct
FROM HumanResources
GROUP BY YEAR(hire_date)
ORDER BY YEAR(hire_date) asc

-- What is the AVG Tenure distribution for each department?

SELECT department
		--,SUM(CASE WHEN termdate <= CAST(getdate() as date) THEN 1 ELSE 0 END) as Tenure
		,avg(DATEDIFF(year, hire_date, termdate)) as tenure
FROM HumanResources
WHERE termdate < CAST(Getdate() as date) 
GROUP BY department
ORDER BY tenure Desc
