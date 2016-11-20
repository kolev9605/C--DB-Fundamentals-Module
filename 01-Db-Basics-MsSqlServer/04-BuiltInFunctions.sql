--Problem 1. Find Names of All Employees by First Name
USE SoftUni
SELECT
	FirstName,
	LastName
FROM
	Employees
WHERE 
	FirstName LIKE 'sa%'


--02. Find Names of All Employees by Last Name
SELECT
	FirstName,
	LastName
FROM
	Employees
WHERE 
	LastName LIKE '%ei%'

--03. Find First Names of All Employess
SELECT 
	FirstName
FROM
	Employees AS e
WHERE
	e.DepartmentID IN (10, 3) AND
	YEAR(e.HireDate) BETWEEN 1995 AND 2005


--04. Find All Employees Except Engineers
SELECT
	FirstName,
	LastName
FROM
	Employees as e
WHERE
	e.JobTitle NOT LIKE '%engineer%'

--05. Find Towns with Name Length
SELECT
	Name
FROM
	Towns as t
WHERE 
	LEN(t.Name) IN (5,6)
ORDER BY
	t.Name

--06. Find Towns Starting With
SELECT
*
FROM
	Towns as t
WHERE 
	t.Name LIKE 'M%' OR
	t.Name LIKE 'K%' OR
	t.Name LIKE 'B%' OR
	t.Name LIKE 'E%'
ORDER BY
	t.Name

--07. Find Towns Not Starting With
SELECT
*
FROM
	Towns as t
WHERE 
	t.Name NOT LIKE 'R%' AND
	t.Name NOT LIKE 'B%' AND
	t.Name NOT LIKE 'D%'
ORDER BY
	t.Name


--08. Create View Employees Hired After
CREATE VIEW V_EmployeesHiredAfter2000  AS
SELECT
	FirstName,
	LastName
FROM
	Employees AS e
WHERE 
	YEAR(e.HireDate) > 2000


--09. Length of Last Name
SELECT
	FirstName,
	LastName
FROM
	Employees AS e
WHERE 
	LEN(e.LastName) = 5


--10. Countries Holding 'A'
USE Geography
SELECT
	c.CountryName,
	c.IsoCode
FROM
	Countries AS c
WHERE
	c.CountryName LIKE '%A%A%A%'
ORDER BY
	c.IsoCode ASC

--11. Mix of Peak and River Names
SELECT
	p.PeakName,
	r.RiverName,
	LOWER(CONCAT(p.PeakName, SUBSTRING(r.RiverName, 2, LEN(r.RiverName)))) as Mix
FROM
	Peaks as p,
	Rivers AS r
WHERE
	RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
ORDER BY
	Mix

--12. Games From 2011 and 2012 Year
USE Diablo
SELECT TOP 50
	Name,
	CONVERT(date, Start) AS Start
FROM 
	Games
WHERE
	Start BETWEEN'20110101' AND '20121231'
ORDER BY 
	Start,
	Name

--13. User Email Providers
SELECT
	Username,
	SUBSTRING(u.Email, CHARINDEX('@', u.Email)+1, LEN(u.Email)) AS 'Email Provider'
FROM
	Users AS u
ORDER BY
	[Email Provider],
	u.Username


--14. Get Users with IPAddress Like Pattern
SELECT
	u.Username,
	u.IpAddress
FROM 
	Users AS u
WHERE
	u.IpAddress LIKE '___.1_%._%.___'
ORDER BY
	u.Username

--15. Show All Games with Duration

SELECT
	g.Name AS Game,
	CASE
		WHEN DATEPART(HOUR, g.Start) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR, g.Start) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN DATEPART(HOUR, g.Start) BETWEEN 18 AND 24 THEN 'Evening'
	END AS [Part of the Day],

	CASE
		WHEN g.Duration <= 3 THEN 'Extra Short'
		WHEN g.Duration BETWEEN 4 AND 6 THEN 'Short'
		WHEN g.Duration > 6 THEN 'Long'
		ELSE 'Extra Long'
	END AS [Duration]
FROM
	Games AS g
ORDER BY
	g.Name,
	[Duration]


--16. Orders Table
SELECT
	ProductName,
	OrderDate,
	DATEADD(day,3,OrderDate) AS [Pay Due],
	DATEADD(month,1,OrderDate) AS [Deliver Due]
FROM
	Orders