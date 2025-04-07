--SQL kommentaar
-- SQL Server Managment Stuudio
-- connect to
-- (localdb)//mssqllocaldb
--Authentification: Windows Auth - admini õigused localhostis
--Authentification: SQL Server Auth - varem loodud kasutajad
--New Query
CREATE DATABASE nazaruk;
--Object Explorer on vaja pidevalt uuendada käsitsi!
USE nazaruk;
tabeli loomine
CREATE TABLE opilane(
opilaneID int Primary Key identity(1,1),
eesnimi varchar(25),
perenimi varchar(30) Unique,
synniaeg date,
aadress TEXT,
opilaskodu bit
);
SELECT * FROM opilane;
--tabeli kustutamine
DROP table opilane;
--andmete lisamine tabelisse
INSERT INTO opilane(eesnimi, perenimi, synniaeg, aadress, opilaskodu)
VALUES ('Mark', 'Maslov', '2007.09.4', 'Tallinn', 0),
('Denis', 'Svarkov', '2007.01.17', 'Tallinn', 0),
('Marat', 'Saunkans', '2007.05.7', 'Maardu', 0),
('Andrei', 'Kulberg', '2006.02.27', 'Kehra', 0)
