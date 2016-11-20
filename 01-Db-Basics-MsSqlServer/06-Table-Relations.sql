-- 01 One-To-One Relationship
CREATE TABLE Passports(
PassportID INT PRIMARY KEY,
PassportNumber VARCHAR(50)
)

CREATE TABLE Persons(
PersonID INT PRIMARY KEY,
FirstName VARCHAR(50),
Salary DECIMAL(8,2),
PassportID INT,
CONSTRAINT FK_Persons_Passports FOREIGN KEY(PassportID) REFERENCES Passports(PassportID)
)

INSERT INTO Passports(PassportID, PassportNumber)
VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2')

INSERT INTO Persons(PersonID, FirstName, Salary, PassportID)
VALUES
(1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101)

-- 02 One-To-Many Relationship
CREATE TABLE Manufacturers(
ManufacturerID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50),
EstablishedOn DATE)

CREATE TABLE Models(
ModelID INT PRIMARY KEY IDENTITY (101,1),
Name VARCHAR(50),
ManufacturerID INT,
FOREIGN KEY(ManufacturerID) REFERENCES Manufacturers(ManufacturerID))

INSERT INTO Manufacturers (Name, EstablishedOn)
VALUES ('BMW', '07/03/1916'), ('Tesla', '01/01/2003'), ('Lada', '01/05/1966')

INSERT INTO Models (Name, ManufacturerID)
VALUES ('X1', 1), ('i6', 1), ('Model S', 2), ('Model X', 2), ('Model 3', 2), ('Nova', 3)

-- 03 Many-To-Many Relationship
CREATE TABLE Students(
StudentID INT PRIMARY KEY,
Name VARCHAR(50)
)

CREATE TABLE Exams(
ExamID INT PRIMARY KEY,
Name VARCHAR(50)
)

CREATE TABLE StudentsExams(
StudentID INT,
ExamID INT,
CONSTRAINT PK_StudentsExams PRIMARY KEY(StudentID, ExamID),
CONSTRAINT FK_StudentsExams_Students FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY(ExamID) REFERENCES Exams(ExamID)
)

INSERT INTO Students(StudentID, Name)
VALUES
(1, 'Mila'),                                     
(2, 'Toni'),
(3, 'Ron')

INSERT INTO Exams(ExamID, Name)
VALUES 
(101, 'Spring MVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g')

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)

--04 Self-join 

CREATE TABLE Teachers(
TeacherID INT PRIMARY KEY,
Name VARCHAR(50),
ManagerID INT,
CONSTRAINT FK_Teachers_Teachers FOREIGN KEY(ManagerID) REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers(TeacherID, Name, ManagerID)
VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101)

--05 Online Store Database

CREATE TABLE Cities(
	CityID int,
	Name varchar(50),
 CONSTRAINT PK_Cities PRIMARY KEY (CityID)
 )

CREATE TABLE Customers(
	CustomerID int,
	Name varchar(50),
	Birthday date,
	CityID int,
 CONSTRAINT PK_Customers PRIMARY KEY(CustomerID)
 )

CREATE TABLE Items(
	ItemID int,
	Name varchar(50),
	ItemTypeID int,
 CONSTRAINT PK_Items PRIMARY KEY (ItemID)
)

CREATE TABLE ItemTypes(
	ItemTypeID int,
	Name varchar(50),
 CONSTRAINT PK_ItemTypes PRIMARY KEY (ItemTypeID)
 )

CREATE TABLE OrderItems(
	OrderID int,
	ItemID int,
 CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID,ItemID)
 )

CREATE TABLE Orders(
	OrderID int,
	CustomerID int,
 CONSTRAINT PK_Orders PRIMARY KEY (OrderID)
 ) 

ALTER TABLE Customers ADD CONSTRAINT FK_Customers_Cities FOREIGN KEY(CityID)
REFERENCES Cities (CityID)

ALTER TABLE Items ADD CONSTRAINT FK_Items_ItemTypes FOREIGN KEY(ItemTypeID)
REFERENCES ItemTypes (ItemTypeID)

ALTER TABLE OrderItems ADD CONSTRAINT FK_OrderItems_Items FOREIGN KEY(ItemID)
REFERENCES Items (ItemID)

ALTER TABLE OrderItems  ADD CONSTRAINT FK_OrderItems_Orders FOREIGN KEY(OrderID)
REFERENCES Orders (OrderID)

ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Customers FOREIGN KEY(CustomerID)
REFERENCES Customers (CustomerID)

-- 06 University Database

CREATE TABLE Majors (
	MajorID INT PRIMARY KEY,
	Name VARCHAR(50)
)

CREATE TABLE Students (
	StudentID INT PRIMARY KEY,
	StudentNumber VARCHAR(50),
	StudentName VARCHAR(50),
	MajorID INT
CONSTRAINT FK_Students_Majors FOREIGN KEY(MajorID) REFERENCES Majors(MajorID)
)

CREATE TABLE Payments (
	PaymentID INT PRIMARY KEY,
	PaymentDate Date,
	PaymentAmount INT,
	StudentID INT
CONSTRAINT FK_Payments_Students FOREIGN KEY(StudentID) REFERENCES Students(StudentID)
)

CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY,
SubjectName VARCHAR(50)
)

CREATE TABLE Agenda(
StudentID INT,
SubjectID INT,
CONSTRAINT PK_Agenda PRIMARY KEY(StudentID, SubjectID),
CONSTRAINT FK_Agenda_Subjects FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID),
CONSTRAINT FK_Agenda_Students FOREIGN KEY(StudentID) REFERENCES Students(StudentID)
)

-- 09 Employee Addresses
SELECT TOP 5 
	e.EmployeeID,
	e.JobTitle,
	e.AddressID,
	a.AddressText
	FROM Employees AS e
	INNER JOIN Addresses AS a
	ON e.AddressID = a.AddressID
	ORDER BY e.AddressID
-- 10 Employee Departments
SELECT TOP 5 
	e.EmployeeID,
	e.FirstName,
	e.Salary,
	a.Name
	FROM Employees AS e
	INNER JOIN Departments AS a
	ON e.DepartmentID = a.DepartmentID
	WHERE e.Salary > 15000
	ORDER BY e.DepartmentID

 -- 11. Employees Without Projects
SELECT TOP 3 
	e.EmployeeID,
	e.FirstName
	FROM Employees AS e
	LEFT OUTER JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	WHERE ep.EmployeeID IS NULL
	ORDER BY e.EmployeeID

 -- 12. Employees With Project
 SELECT TOP 5
	e.EmployeeID,
	e.FirstName,
	p.Name
	FROM Employees AS e
	LEFT OUTER JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	LEFT OUTER JOIN Projects as p
	ON p.ProjectID = ep.ProjectID
	WHERE p.StartDate > '20020813'
	AND p.EndDate is NULL
	ORDER BY e.EmployeeID

 -- 13. Employee 24
SELECT
	e.EmployeeID,
	e.FirstName,
	p.Name
	FROM Employees AS e
	LEFT OUTER JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	LEFT OUTER JOIN Projects as p
	ON p.ProjectID = ep.ProjectID
	AND p.StartDate < '20050101'
	WHERE e.EmployeeID = 24
	ORDER BY e.EmployeeID

 -- 14. Employee Manager
SELECT
	e1.EmployeeID,
	e1.FirstName,
	e1.ManagerID,
	e2.FirstName
	FROM Employees AS e1
	LEFT OUTER JOIN Employees AS e2
	ON e1.ManagerID = e2.EmployeeID
	WHERE e1.ManagerID = 3
	OR e1.ManagerID = 7
	ORDER BY e1.EmployeeID

 -- 15. Highest Peaks in Bulgaria
 SELECT c.CountryCode
	  ,m.MountainRange
      ,p.PeakName
	  ,p.Elevation 
  FROM Countries AS c
 INNER JOIN MountainsCountries AS mc
    ON c.CountryCode = mc.CountryCode
 INNER JOIN Mountains as m
    ON m.Id = mc.MountainId
 INNER JOIN Peaks as p
    ON p.MountainId = m.Id
 WHERE c.CountryCode = 'BG'
   AND p.Elevation > 2835
 ORDER BY Elevation DESC

 -- 16. Count Mountain Ranges
SELECT c.CountryCode
	  ,COUNT(*) AS MountainRange
  FROM Countries AS c
 INNER JOIN MountainsCountries AS mc
    ON c.CountryCode = mc.CountryCode
 INNER JOIN Mountains as m
    ON m.Id = mc.MountainId
 WHERE c.CountryCode IN ('US', 'RU', 'BG')
 GROUP BY c.CountryCode

 -- 17. Countries with or without rivers
SELECT TOP 5
	   c.CountryName
	  ,r.RiverName
  FROM Countries AS c
 LEFT JOIN CountriesRivers AS cr
    ON c.CountryCode = cr.CountryCode
 LEFT JOIN Rivers as r
    ON r.Id = cr.RiverId
 WHERE c.ContinentCode = 'AF'
 ORDER BY c.CountryName

 -- 18. Continents and Currencies

SELECT cur.ContinentCode, MAX(cur.CurrencyUsage) AS MaxCurrencyUsage
  INTO CurrencyUsage
  FROM
(SELECT co.ContinentCode, cu.CurrencyCode, COUNT(*) AS CurrencyUsage
  FROM [Geography].[dbo].[Countries] AS co
 INNER JOIN [Geography].[dbo].[Currencies] AS cu
    ON co.CurrencyCode = cu.CurrencyCode
 GROUP BY co.ContinentCode, cu.CurrencyCode) AS cur
 GROUP BY cur.ContinentCode
HAVING MAX(cur.CurrencyUsage) > 1
 
 SELECT cur.* 
   FROM  
 (SELECT co.ContinentCode, cu.CurrencyCode, COUNT(*) AS CurrencyUsage
  FROM [Geography].[dbo].[Countries] AS co
 INNER JOIN [Geography].[dbo].[Currencies] AS cu
    ON co.CurrencyCode = cu.CurrencyCode
 GROUP BY co.ContinentCode, cu.CurrencyCode) AS cur
 INNER JOIN CurrencyUsage cu
    ON cu.ContinentCode = cur.ContinentCode
   AND cu.MaxCurrencyUsage = cur.CurrencyUsage
 ORDER BY ContinentCode

DROP TABLE CurrencyUsage

 -- 19. Count of countries without mountains
 SELECT COUNT(*)
  FROM Countries AS c
  LEFT JOIN MountainsCountries AS mc
    ON c.CountryCode = mc.CountryCode
 WHERE mc.MountainId IS NULL


 -- 20. Highest Peak and Longest River by Country
SELECT TOP 5
  c.CountryName,
  MAX(p.Elevation) AS HighestPeakElevation,
  MAX(r.Length) AS LongestRiverLength
FROM
  Countries c
  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains m ON m.Id = mc.MountainId
  LEFT JOIN Peaks p ON p.MountainId = m.Id
  LEFT JOIN CountriesRivers cr ON cr.CountryCode = c.CountryCode
  LEFT JOIN Rivers r ON r.Id = cr.RiverId
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName ASC

-- 21. Highest Peak Name and Elevation by Country
SELECT TOP 5 *
FROM (
			SELECT
			  c.CountryName AS [Country],
			  p.PeakName AS [Highest Peak Name],
			  p.Elevation AS [Highest Peak Elevation],
			  m.MountainRange AS [Mountain]
			FROM
			  Countries c
			  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
			  LEFT JOIN Mountains m ON m.Id = mc.MountainId
			  LEFT JOIN Peaks p ON p.MountainId = m.Id
			WHERE p.Elevation =
			  (SELECT MAX(p.Elevation)
			   FROM MountainsCountries mc
				 LEFT JOIN Mountains m ON m.Id = mc.MountainId
				 LEFT JOIN Peaks p ON p.MountainId = m.Id
			   WHERE c.CountryCode = mc.CountryCode)
			UNION
			SELECT
			  c.CountryName AS [Country],
			  '(no highest peak)' AS [Highest Peak Name],
			  0 AS [Highest Peak Elevation],
			  '(no mountain)' AS [Mountain]
			FROM
			  Countries c
			  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
			  LEFT JOIN Mountains m ON m.Id = mc.MountainId
			  LEFT JOIN Peaks p ON p.MountainId = m.Id
			WHERE 
			  (SELECT MAX(p.Elevation)
			   FROM MountainsCountries mc
				 LEFT JOIN Mountains m ON m.Id = mc.MountainId
				 LEFT JOIN Peaks p ON p.MountainId = m.Id
			   WHERE c.CountryCode = mc.CountryCode) IS NULL
   ) AS c
ORDER BY Country, [Highest Peak Name]