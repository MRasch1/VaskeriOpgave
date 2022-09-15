USE master
GO
IF DB_ID ('BBB') IS NOT NULL
BEGIN
ALTER DATABASE BBB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE BBB
END
GO
CREATE DATABASE BBB
GO
USE BBB
GO

CREATE TABLE Vaskerier(
Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
Navn VARCHAR(20),
Åbner TIME(0) NOT NULL,
Lukker TIME(0) NOT NULL
);
GO
INSERT INTO Vaskerier VALUES('Whitewash Inc.', '08:00', '20:00')
INSERT INTO Vaskerier VALUES('Double Bubble', '02:00', '22:00')
INSERT INTO Vaskerier VALUES('Wash & Coffee', '12:00', '20:00')
GO
CREATE TABLE Brugere(
Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
Navn VARCHAR(50),
E_mail NVARCHAR(30) UNIQUE,
[Password] NVARCHAR(20),
Konto DECIMAL,
Vaskeri INT,
Oprettet DATE,
CONSTRAINT FK_VaskeriBruger FOREIGN KEY (Vaskeri) REFERENCES Vaskerier(Id)
);
GO
INSERT INTO Brugere VALUES('John', 'john_doe66@gmail.com', 'password',100.00,2,'2021-02-15')
INSERT INTO Brugere VALUES('Neil Armstrong', 'firstman@nasa.gov', 'eagleLander69',1000.00,1,'2021-02-10')
INSERT INTO Brugere VALUES('Batman', 'noreply@thecave.com', 'Rob1n',500.00,3,'2020-03-10')
INSERT INTO Brugere VALUES('Goldman Sachs', 'moneylaundering@gs.com', 'NotRecognized',100000.00,1,'2021-01-01')
INSERT INTO Brugere VALUES('50 Cent', '50cent@gmail.com', 'ItsMyBirthday',0.50,3,'2020-07-06')
GO
CREATE TABLE Maskiner(
Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
Navn VARCHAR(50),
Pris_Pr_Vask DECIMAL,
Vasketid_i_minutter INT,
Vaskeri INT,
CONSTRAINT FK_VaskeriMaskine FOREIGN KEY (Vaskeri) REFERENCES Vaskerier(Id)
);
GO
INSERT INTO Maskiner VALUES('Mielle 911 Turbo',5.00,60,2)
INSERT INTO Maskiner VALUES('Siemons IClean',10000.00,30,1)
INSERT INTO Maskiner VALUES('Electrolax FX-2',15.00,45,2)
INSERT INTO Maskiner VALUES('NASA Spacewasher 8000',500.00,5,1)
INSERT INTO Maskiner VALUES('The Lost Sock',3.50,90,3)
INSERT INTO Maskiner VALUES('Yo Mama',0.50,120,3)
GO
CREATE TABLE Bookinger(
Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
Tidspunkt_for_vask DATETIME,
BrugerId INT,
MaskineId INT,
CONSTRAINT FK_BrugerId FOREIGN KEY (BrugerId) REFERENCES Brugere(Id),
CONSTRAINT FK_MaskineId FOREIGN KEY (MaskineId) REFERENCES Maskiner(Id)
);
GO
INSERT INTO Bookinger VALUES('2021-02-26 12:00:00',1,1)
INSERT INTO Bookinger VALUES('2021-02-26 16:00:00',1,3)
INSERT INTO Bookinger VALUES('2021-02-26 08:00:00',2,4)
INSERT INTO Bookinger VALUES('2021-02-26 15:00:00',3,5)
INSERT INTO Bookinger VALUES('2021-02-26 20:00:00',4,2)
INSERT INTO Bookinger VALUES('2021-02-26 19:00:00',4,2)
INSERT INTO Bookinger VALUES('2021-02-26 10:00:00',4,2)
INSERT INTO Bookinger VALUES('2021-02-26 16:00:00',5,6)
GO

--BEGIN TRAN
 
--UPDATE Person 
--SET    Lastname = 'Lucky', 
--        Firstname = 'Luke' 
--WHERE  PersonID = 1
 
--SELECT @@TRANCOUNT AS OpenTransactions

BEGIN TRAN
UPDATE Bookinger
SET Tidspunkt_for_vask = '2022-02-26 12:00:00',
BrugerId = 4,
MaskineId = 2
WHERE Id = 5
COMMIT TRAN
GO
CREATE VIEW BookingerView AS
	SELECT Tidspunkt_for_vask, Brugere.Navn AS Bruger_Navn, Maskiner.Navn AS Maskine_Navn, Maskiner.Pris_Pr_Vask
	FROM Bookinger
	JOIN Brugere ON Bookinger.BrugerId  = Brugere.Id
	JOIN Maskiner ON Bookinger.MaskineId  = Maskiner.Id
GO
SELECT * FROM BookingerView 
SELECT @@TRANCOUNT AS OpenTransactions
GO
UPDATE Brugere
SET Password = 'SelinaKyle'
WHERE Navn = 'Batman'
GO
SELECT * FROM Brugere WHERE E_mail like '%@%'
GO
SELECT * FROM Maskiner
GO
SELECT Maskiner.Navn, STRING_AGG(Bookinger.MaskineId,', ') AS Bookinger
FROM Bookinger
JOIN Maskiner ON Bookinger.MaskineId = Maskiner.Id
GROUP BY Navn
GO