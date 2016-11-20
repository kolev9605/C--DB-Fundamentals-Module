USE Gringotts
GO

--01. Records’ Count
SELECT COUNT(*) AS [Count] FROM WizzardDeposits 

--02. Longest Magic Wand
SELECT
	MAX(MagicWandSize) AS LongestMagicWand
FROM 
	WizzardDeposits


--03. Longest Magic Wand per Deposit Groups
SELECT
	w.DepositGroup, 
	MAX(MagicWandSize) AS LongestMagicWand
FROM 
	WizzardDeposits as w
GROUP BY 
	w.DepositGroup


--04. Smallest Deposit Group per Magic Wand Size
SELECT
	w.DepositGroup, AVG(w.MagicWandSize) AS AverageSize
INTO
	AverageWandSize	
FROM 
	WizzardDeposits as w
GROUP BY
	w.DepositGroup

SELECT 
	a.DepositGroup 
FROM 
	AverageWandSize as a
WHERE 
	AverageSize = (SELECT MIN(AverageSize) FROM AverageWandSize)
DROP TABLE 
	AverageWandSize

--05. Deposits Sum
SELECT
	w.DepositGroup,
	SUM(w.DepositAmount)
FROM 
	WizzardDeposits as w
GROUP BY
	w.DepositGroup

--06. Deposits Sum for Ollivander Family
SELECT
	w.DepositGroup,
	SUM(w.DepositAmount)
FROM 
	WizzardDeposits as w
WHERE
	w.MagicWandCreator = 'Ollivander family'
GROUP BY
	w.DepositGroup

--07. Deposits Filter
SELECT
	w.DepositGroup,
	SUM(w.DepositAmount)
FROM 
	WizzardDeposits as w
WHERE
	w.MagicWandCreator = 'Ollivander family'
GROUP BY
	w.DepositGroup
HAVING
	SUM(w.DepositAmount) < 150000
ORDER BY 
	SUM(w.DepositAmount) DESC

--08. Deposit Charge
SELECT
	w.DepositGroup,
	w.MagicWandCreator,
	MIN(w.DepositCharge) AS MinDepositCharge
FROM 
	WizzardDeposits as w
GROUP BY
	w.DepositGroup,
	w.MagicWandCreator

--09. Age Groups
  SELECT CASE
			WHEN w.Age BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN w.Age BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN w.Age BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN w.Age BETWEEN 31 AND 40 THEN '[31-40]'
			WHEN w.Age BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN w.Age BETWEEN 51 AND 60 THEN '[51-60]'
			WHEN w.Age >= 61 THEN '[61+]'
		END AS 'SizeGroup'
		,COUNT(*) as WizzardsCount
  FROM WizzardDeposits AS w
 GROUP BY
		CASE
			WHEN w.Age BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN w.Age BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN w.Age BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN w.Age BETWEEN 31 AND 40 THEN '[31-40]'
			WHEN w.Age BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN w.Age BETWEEN 51 AND 60 THEN '[51-60]'
			WHEN w.Age >= 61 THEN '[61+]'
		END


--10. First Letter
SELECT
	DISTINCT LEFT(w.FirstName,1)
FROM 
	WizzardDeposits as w
WHERE
	w.DepositGroup = 'Troll Chest'
ORDER BY
	LEFT(w.FirstName,1)

--11. Average Interest
SELECT
	w.DepositGroup,
	w.IsDepositExpired,
	AVG(w.DepositInterest)
FROM
	WizzardDeposits AS w
WHERE
	w.DepositStartDate > '1985-01-01'
GROUP BY
	w.DepositGroup,
	w.IsDepositExpired
ORDER BY 
	w.DepositGroup DESC, 
	w.IsDepositExpired ASC


--12. Rich Wizard, Poor Wizard
SELECT w.FirstName AS HostWizard
	  ,w.DepositAmount AS HostDeposit
	  ,LEAD(w.FirstName) OVER (ORDER BY w.ID) AS GuestWizard
	  ,LEAD(w.DepositAmount) OVER (ORDER BY w.ID) AS GuestDeposit
  INTO RichWizardPoorWizard
  FROM WizzardDeposits AS w

SELECT SUM(r.HostDeposit-r.GuestDeposit) AS SumDifference FROM RichWizardPoorWizard AS r
DROP TABLE RichWizardPoorWizard


--13. Employees Minimum Salaries
USE SoftUni
SELECT
	e.DepartmentID,
	MIN(e.Salary) AS MinimumSalary
FROM
	Employees as e
WHERE
	e.DepartmentID IN (2,5,7) AND
	e.HireDate > '20000101'
GROUP BY
	e.DepartmentID

--14.	Employees Average Salaries


SELECT * INTO NewEmployees
FROM Employees AS e
WHERE e.Salary > 30000

DELETE FROM NewEmployees 
 WHERE ManagerID = 42

UPDATE NewEmployees
   SET Salary = Salary + 5000
 WHERE DepartmentID = 1

SELECT [DepartmentID]
      ,AVG(Salary) AS AverageSalary
  FROM NewEmployees AS e
 GROUP BY [DepartmentID]

DROP TABLE NewEmployees


--15. Employees Maximum Salaries

USE SoftUni
SELECT
	e.DepartmentID,
	MAX(e.Salary) AS MinimumSalary
FROM
	Employees as e
GROUP BY
	e.DepartmentID
HAVING
	MAX(e.Salary) NOT BETWEEN 30000 AND 70000


--16. Employees Count Salaries
SELECT COUNT(*) AS EmployeeCount
  FROM Employees AS e
 WHERE e.ManagerID IS NULL


--17. 3rd Highest Salary
SELECT DISTINCT
	   DepartmentID
	  ,Salary
      ,DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
  INTO SalaryRanks
  FROM [SoftUni].[dbo].[Employees] AS e

  SELECT DepartmentID, Salary FROM SalaryRanks AS s
   WHERE s.SalaryRank = 3

  DROP TABLE SalaryRanks

--18. Salary Challenge
SELECT TOP 10
	e.FirstName,
	e.LastName,
	e.DepartmentID
FROM
	Employees AS e
INNER JOIN (SELECT
			DepartmentID,
			AVG(Salary) AS AverageSalary
		FROM
			Employees
		GROUP BY
			DepartmentID) as d
ON 
	e.DepartmentID = d.DepartmentID
WHERE
	e.Salary > d.AverageSalary
ORDER BY
	e.DepartmentID