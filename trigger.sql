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
