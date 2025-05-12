create database trigerTIT;
use trigerTIT;
--tabel, mida automaatselt täidab triger
create table logi(
id int primary key identity(1,1),
tegevus varchar(25),
kasutaja varchar(25),
aeg datetime,
andmed TEXT
);

--tabel, millega töötab kasutaja
create table puud(
puuID int primary key identity(1,1),
puuNimi varchar(25),
pikkus int,
aasta int
);
insert into puud(puuNimi,pikkus,aasta)
values ('Kask',25,2018);
select * from puud;
--triger, mis jälgib tabeli puud täitmine (lisamine)
create trigger puuLisamine
on puud
for insert
as
insert into logi(kasutaja,tegevus,aeg,andmed)
select
SYSTEM_USER,
'puu on lisatud',
GETDATE(),
CONCAT (inserted.puuNimi, ', ' ,inserted.pikkus, ', ' ,inserted.aasta)
from inserted;
--kontroll
insert into puud(puuNimi, pikkus, aasta)
VALUES ('Vaher', 23, 2001);
select * from puud;
select * from logi;
drop trigger puuLisamine;
--triger, mis jälgib tabelis kustutamisest
create trigger puuKustutamine
on puud
for DELETE
as
insert into logi(kasutaja,tegevus,aeg,andmed)
select
SYSTEM_USER,
'puu on kustutatud',
GETDATE(),
CONCAT (deleted.puuNimi, ', ' ,deleted.pikkus, ', ' ,deleted.aasta)
from deleted;
DELETE from puud where puuID=2;
select * from puud;
select * from logi;

--triger, mis jälgib tabelis uuendamist
create trigger puuUuendamine
on puud
for UPDATE
as
insert into logi(kasutaja,tegevus,aeg,andmed)
select
SYSTEM_USER,
'puu on uuendatud',
GETDATE(),
CONCAT (
'vana puu info -  ', deleted.puuNimi, ', ' ,deleted.pikkus, ', ' ,deleted.aasta,
'uue puu info -  ', inserted.puuNimi, ', ' ,inserted.pikkus, ', ' ,inserted.aasta
)
from deleted inner join inserted
on deleted.puuID=inserted.puuID;
--kontroll
update puud set pikkus=253123, aasta=1941
where puuID=3;
select * from puud;
select * from logi;
--ülesanne
create table products(
product_id int primary key identity(1,1),
product_name varchar(30),
brand_id int,
category_id int,
model_year int,
list_price int
);
CREATE TABLE product_audits(
    change_id INT IDENTITY PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DEC(10,2) NOT NULL,
    updated_at DATETIME NOT NULL,
    operation CHAR(3) NOT NULL,
    CHECK(operation = 'INS' or operation='DEL')
);
drop trigger trg_product_audit;
CREATE TRIGGER trg_product_audit
ON products
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO product_audits(
        product_id, 
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price, 
        updated_at, 
        operation
    )
    SELECT
        i.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        i.list_price,
        GETDATE(),
        'INS'
    FROM
        inserted i
    UNION ALL
    SELECT
        d.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        d.list_price,
        GETDATE(),
        'DEL'
    FROM
        deleted d;
END
--kontroll
INSERT INTO products(
    product_name, 
    brand_id, 
    category_id, 
    model_year, 
    list_price
)
VALUES (
    'Test product',
    1,
    1,
    2018,
    599
);
SELECT * FROM product_audits;
DELETE FROM 
    products
WHERE 
    product_id = 1;


create database nazaruk;
use nazaruk;

create table firma(
firmaID int not null primary key identity(1,1),
firmanimi varchar(50) unique,
aadress varchar(50),
telefon varchar(50));
drop table firma;
drop table praktikabaas;

create table praktikabaas(
praktikabaasID int not null primary key identity(1,1),
firmaID int,
praktikatingimused varchar(50),
arvutiprogramm varchar(20),
juhendajaID int,
FOREIGN key (firmaID) references firma(firmaID),
FOREIGN KEY (juhendajaID) references praktikajuhendaja(praktikajuhendajaID));

INSERT INTO praktikabaas (firmaID, praktikatingimused, arvutiprogramm, juhendajaID)
VALUES (4, '10-2', 'AutoCAD', 1),
       (5, '7-9', 'Photoshop', 8);

create table praktikajuhendaja(
praktikajuhendajaID int not null primary key identity(1,1),
eesnimi varchar(20),
perekonnanimi varchar(20),
synniaeg date,
telefon varchar(25));

select * from praktikajuhendaja;
INSERT INTO praktikajuhendaja (eesnimi, perekonnanimi, synniaeg, telefon)
VALUES 
    ('Jaan', 'Tamm', '1980-03-15', '+372 5551 2345'),
    ('Mari', 'Pill', '1992-07-22', '+372 5551 6789'),
    ('Andres', 'Kivi', '1985-11-10', '+372 5552 3456'),
    ('Liis', 'Mets', '1990-04-30', '+372 5553 7890'),
    ('Peeter', 'Laas', '1978-06-05', '+372 5554 1234');

insert into firma(firmanimi,aadress,telefon)
values('OÜ TarkusTech', 'Põllu 5, 10123 Tallinn, Eesti', '+37255512345'),
('AS LoodusVägi', 'Metsapark 15, 50404 Tartu, Eesti', '+37256439876'),
('OÜ Ehituse Gurmaan', 'Võidujooks 10, 11314 Tallinn, Eesti', '+37251153456'),
('Büroo Innovatsioon', 'Õpetaja 3, 10123 Tallinn, Eesti', '+37256221100'),
('TecnoMüüja OÜ', 'Kaugeliikuri 7, 60022 Pärnu, Eesti', '+37253402020')
select * from firma;

drop table logi;
create table logi(
id int primary key identity(1,1),
kasutaja varchar (40),
aeg datetime,
tegevus varchar(50),
andmed text);
drop trigger kirjeLisamine;
create trigger kirjeLisamine
on praktikabaas
for insert
as
insert into logi(kasutaja,aeg,tegevus,andmed)
select SYSTEM_USER,GETDATE(),'lisatud',
CONCAT(inserted.firmaID, ', ', inserted.praktikatingimused, ', ', inserted.arvutiprogramm, ', ', inserted.juhendajaID)
from inserted;

select * from logi;
select * from praktikabaas;

create trigger kirjeuuendamine
on praktikabaas
for update
as
insert into logi(kasutaja,aeg,tegevus,andmed)
select SYSTEM_USER,GETDATE(),'lisatud',
CONCAT
(deleted.firmaID, ', ', deleted.praktikatingimused, ', ', deleted.arvutiprogramm, ', ', deleted.juhendajaID, ', '
inserted.firmaID, ', ', inserted.praktikatingimused, ', ', inserted.arvutiprogramm, ', ', inserted.juhendajaID)
from deleted inner join inserted
on deleted.puuID=inserted.puuID;




-----eraldi triger, et jälgida kohe kolm tabelit (insert)
USE [nazaruk]
GO
/****** Object:  Trigger [dbo].[kirjeLisamine]    Script Date: 12.05.2025 12:15:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER trigger [dbo].[kirjeLisamine]
on [dbo].[praktikabaas]
for insert
as
insert into logi(kasutaja,aeg,tegevus,andmed)
select SYSTEM_USER,GETDATE(),'lisatud',
CONCAT(praktikajuhendaja.eesnimi,', ', praktikajuhendaja.perekonnanimi, ', ', firma.firmanimi, ', ',firma.aadress, ', ', inserted.praktikatingimused, ', ', inserted.arvutiprogramm, ', ', inserted.juhendajaID)
from inserted
inner join firma on inserted.firmaID=firma.firmaID
inner join praktikajuhendaja on inserted.juhendajaID=praktikajuhendaja.praktikajuhendajaID;
