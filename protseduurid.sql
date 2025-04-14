Create database nazaruk;
use nazaruk;

create table linnad(
linnID int primary key identity (1,1),
linnNimi varchar(30) unique,
elanikeARV int not null,
maakond varchar(25)
);
--protseduur, mis lisab (INSERT)tabelisse andmed ja 
--(SELECT)kohe näitab tabeli
create procedure lisaLinn
@linnNimi varchar(30),
@elanikeARV int,
@maakond varchar(25)
as
begin
insert into linnad(linnNimi, elanikeARV, maakond)
values (@linnNimi, @elanikeARV, @maakond);
select * from linnad;
end;

--kutse
exec lisaLinn	'Kose', 6000, 'Kose';

--protseduuri kustutamine
drop procedure lisaLinn;

--protseduur, mis kustutab tabelist LinnID järgi
create procedure kustutalinn
@id int
as
begin
select * from linnad;
delete from linnad where linnID=@id;
select * from linnad;
end;
--kutse
exec kustutalinn 4;

--protseduur, mis uuendab tabeli ja suurendab elanike arv 10%

create procedure uuendaLinn
@arv decimal(5,2)
as
begin
select * from linnad;
update linnad set elanikeARV=elanikeARV*@arv;
select * from linnad;
end;

--kutse

exec uuendaLinn 0.5;
drop procedure uuendaLinn;
update linnad set elanikeARV=20000;
