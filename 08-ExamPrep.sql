--DDL
CREATE TABLE DepositTypes(
DepositTypeID INT PRIMARY KEY,
[Name] varchar(20)
)

CREATE TABLE Deposits(
DepositID INT PRIMARY KEY IDENTITY,
Amount DECIMAL(10,2),
StartDate DATE,
EndDate DATE,
DepositTypeID INT FOREIGN KEY REFERENCES DepositTypes(DepositTypeID),
CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE EmployeesDeposits(
EmployeeID INT FOREIGN KEY REFERENCES [dbo].[Employees](EmployeeID),
DepositID INT FOREIGN KEY REFERENCES Deposits(DepositID),
CONSTRAINT PK_EmployeesDeposits PRIMARY KEY NONCLUSTERED (EmployeeID, DepositID)
)

CREATE TABLE CreditHistory(
CreditHistoryID INT PRIMARY KEY,
Mark CHAR(1),
StartDate DATE,
EndDate DATE,
CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE Payments(
PayementID INT PRIMARY KEY,
[Date] DATE,
Amount DECIMAL(10,2),
LoanID INT FOREIGN KEY REFERENCES [dbo].[Loans](LoanID)
)

CREATE TABLE Users(
UserID INT PRIMARY KEY,
UserName VARCHAR(20),
[Password] VARCHAR(20),
CustomerID INT UNIQUE FOREIGN KEY REFERENCES [dbo].[Customers](CustomerID)
)

ALTER TABLE Employees
ADD ManagerID INT FOREIGN KEY REFERENCES [dbo].[Employees](EmployeeID)

--DML
INSERT INTO [dbo].[DepositTypes](DepositTypeID,Name)
VALUES
(1,	'Time Deposit'),
(2,	'Call Deposit'),
(3,	'Free Deposit')

INSERT INTO Deposits
(Amount, StartDate, EndDate, DepositTypeID, CustomerID)
SELECT 
	CASE
		WHEN c.DateOfBirth > '1980-01-01' THEN 1000
		ELSE 1500
	END
	+
	CASE
		WHEN c.Gender = 'm' THEN 100
		WHEN c.Gender = 'f' THEN 200
	END AS Amount,
	GETDATE() AS StartDate,
	NULL AS EndDate, 
	CASE 
		WHEN c.CustomerID > 15 THEN 3
		WHEN c.CustomerID % 2 = 0 THEN 2
		WHEN c.CustomerID % 2 != 0 THEN 1		
	END AS DepositTypeID,
	c.CustomerID
FROM Customers AS c
WHERE c.CustomerID < 20

INSERT INTO [dbo].[EmployeesDeposits](EmployeeID, DepositID)
VALUES
(15,4),
(20,15),
(8,	7),
(4,	8),
(3,	13),
(3,	8),
(4,10),
(10,1),
(13,4),
(14,9)

UPDATE [dbo].[Employees] 
SET ManagerID = 
	CASE 
		WHEN EmployeeID BETWEEN 2 AND 10 THEN 1
		WHEN EmployeeID BETWEEN 12 AND 20 THEN 11
		WHEN EmployeeID BETWEEN 22 AND 30 THEN 21
		WHEN EmployeeID IN (11,21) THEN 1
	END

DELETE FROM EmployeesDeposits
WHERE EmployeeID = 3
OR DepositID = 9

--Querying
--
SELECT EmployeeID,HireDate, Salary, BranchID 
FROM Employees
WHERE Salary > 2000 AND  HireDate > '2009-06-15'
--
SELECT FirstName, 
DateOfBirth, 
DATEDIFF(YEAR, DateOfBirth, '01-10-2016') AS Age
FROM Customers
WHERE DATEDIFF(YEAR, DateOfBirth, '01-10-2016') BETWEEN 40 AND 50

--
SELECT
CustomerID,
FirstName,
LastName,
Gender,
CityName
FROM Customers as cu
INNER JOIN [dbo].[Cities] as ci
ON ci.CityID = cu.CityID
WHERE (cu.LastName LIKE 'Bu%' 
OR cu.FirstName LIKE '%a')
AND Len(ci.CityName) >= 8

--
SELECT 
TOP 5
e.EmployeeID,
FirstName,
AccountNumber
FROM Employees AS e
INNER JOIN EmployeesAccounts AS ea
ON e.EmployeeID = ea.EmployeeID
INNER JOIN Accounts AS a
ON ea.AccountID = a.AccountID
WHERE YEAR(a.StartDate) > 2012
ORDER BY e.FirstName DESC

--
SELECT
CityName,
b.Name,
COUNT(*) AS EmployeesCount
FROM Cities as c
INNER JOIN Branches AS b
ON c.CityID = b.CityID
INNER JOIN Employees AS e
ON b.BranchID = e.BranchID
WHERE c.CityID != 3 AND c.CityID != 4
GROUP BY CityName, b.Name
HAVING COUNT(*) > 2

--
SELECT
SUM(l.Amount) AS TotalLoanAmount,
MAX(l.Interest) AS MaxInterest,
MIN(e.Salary) AS MinEmployeeSalary
FROM EmployeesLoans AS el
INNER JOIN Employees AS e
ON el.EmployeeID = e.EmployeeID
INNER JOIN Loans AS l
ON el.LoanID = l.LoanID

--

SELECT
FirstName, 
CityName
FROM Employees AS e
INNER JOIN Branches as b
ON e.BranchID = b.BranchID
INNER JOIN Cities as c
ON b.CityID = c.CityID
UNION ALL
SELECT
c.FirstName,
ci.CityName
FROM Customers AS c
INNER JOIN Cities as ci
ON c.CityID = ci.CityID


SELECT
       e.FirstName
      ,c.CityName
  FROM Employees AS e
 INNER JOIN Branches AS b
    ON b.BranchID = e.BranchID
 INNER JOIN Cities AS c
    ON c.CityID = b.CityID
 UNION ALL
SELECT 
	   cu.FirstName
      ,ci.CityName
  FROM Customers AS cu
 INNER JOIN Cities AS ci
    ON cu.CityID = ci.CityID