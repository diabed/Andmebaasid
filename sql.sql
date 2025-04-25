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

insert into hinne
( opilaneID, hinne, oppeaine)
values ('4','4', 'Andmebaasid');

select * from opilane;

select * from hinne join opilane
on hinne.opilaneID=opilane.opilaneID;

Create table opetaja(
opetajaID int Primary Key identity(1,1),
nimi varchar(20),
perenimi varchar(20),
telefon text
);

select * from opetaja;

insert into opetaja 
(nimi, perenimi, telefon)
Values ('Jekaterina', 'Rätsep', '37256239572'),
('Irina', 'Merkulova', '37256385895'),
('Mikhail', 'Agapov', '3957192');

drop table opetaja;

alter table ryhm
ADD foreign key (opetajaID) references opetaja(opetajaID);

alter table ryhm ADD opetajaID int;

create database nazaruk;
use nazaruk;
create table loomad(
loomaID int primary key identity (1,1),
nimi varchar(25),
liik varchar(25),
vanus varchar(10)
);
insert into loomad(nimi, liik, vanus)
values ('Rebane', 'Kiskja', '10-12'),
('Pruunkaru', 'Kiskja', '30-35')
drop table loomad;
select * from loomad;
--kustutamise protseduur
create procedure loomadekustutamine
@id int
as
begin
select * from loomad;
delete from loomad where loomaID=@id;
select * from loomad;
end;
exec loomadekustutamine 4;
insert into loomad(nimi, liik, vanus)
values ('Pruunkaru', 'Kiskja', '30-35')
--lisamise protseduur
create procedure loomadelisamine
@nimi varchar(30),
@liik varchar(25),
@vanus varchar(10)
as
begin
insert into loomad(nimi, liik, vanus)
values (@nimi, @liik, @vanus);
select * from loomad;
end;
exec loomadelisamine 'Lõvi', 'Kiskja', '20-30';
--uuendamise protseduur
create procedure uuendamine
as
begin
select * from loomad;
update loomad set vanus=52;
select * from loomad;
end;
drop procedure loomadelisamine;
exec uuendamine;

create procedure jagamine
@arv decimal(5,2)
as
begin
select * from loomad;
update loomad set vanus=vanus*@arv;
select * from loomad;
end;
exec jagamine 0.5;

create procedure vanemadloomad
@vanus int 
as
begin
select * from loomad
where vanus >=@vanus;
select * from loomad;
end;
exec vanemadloomad 53;
