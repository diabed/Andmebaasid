--SQL kommentaar
-- XAMPP Control Panel (Start Apache, Start MySQL)
-- connect to
-- localhost
--Authentification: 
--kasutajanimi - root 
-- parool ei ole
--SQL:
CREATE DATABASE nazaruk;
--Object Explorer on vaja pidevalt uuendada käsitsi!
vali hiirega andmebaasi
--tabeli loomine
CREATE TABLE opilane(
opilaneID int Primary Key AUTO_INCREMENT,
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

-- järgmine tund
CREATE DATABASE nazaruk;
--Object Explorer on vaja pidevalt uuendada käsitsi!
USE nazaruk;
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
--tabel ryhm
--identity(1,1) automaatselt täidab 1,2,3..
create table ryhm(
ryhmID int not null primary key identity(1,1),
ryhm varchar(10) unique,
osakond varchar(20)
);
insert into ryhm(ryhm, osakond)
Values ('TITpv23', 'IT'), ('KRRpv24','Rätsepp');

Select * from ryhm;

--lisame uus veerg RyhmID tabelisse opilane
alter table opilane ADD ryhmID int;
select * from opilane;
--lisame foreign key

ALTER TABLE opilane
ADD foreign key (ryhmID) references ryhm(ryhmID);

--foreign key kontroll

INSERT INTO opilane
(eesnimi, perenimi, synniaeg, aadress, opilaskodu, ryhmID)
VALUES ('Artjem', 'Jegorov', '2003.04.11', 'Tallinn', 0, 2);

select * from opilane;
--kasutame seos tabelite vahel - JOIN
select * from opilane join ryhm
on opilane.ryhmID=ryhm.ryhmID;

select opilane.perenimi, ryhm.ryhm from opilane join ryhm
on opilane.ryhmID=ryhm.ryhmID;
--lihtsam vaade
select o.perenimi, r.ryhm, o.aadress
from opilane o join ryhm r
on o.ryhmID=r.ryhmID;

create table hinne(
hinneID int primary key identity(1,1),
opilaneID int,
hinne int,
oppeaine varchar(20)
);

select * from hinne;
alter table hinne
ADD foreign key (opilaneID) references opilane(opilaneID);

create table opetaja(
opetajaID int PRIMARY KEY AUTO_INCREMENT,
    nimi varchar(20),
    perenimi varchar(20),
    telefon text
);

insert into ryhm(ryhm, osakond, opetajaID)
Values ('TITpv23', 'IT', 3), ('KRRpv24','Rätsepp', 1), ('TITpv24', 'IT', 2);

insert into opetaja(nimi, perenimi, telefon)
Values ('Jekaterina', 'Rätsep', 37256239572),
('Irina', 'Merkulova', 37256385895),
('Mikhail', 'Agapov', 880084675349572);
