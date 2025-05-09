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
