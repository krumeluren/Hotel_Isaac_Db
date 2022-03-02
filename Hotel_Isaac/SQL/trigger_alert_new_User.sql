use Hotel_Isaac_Db
go

-- Trigger. Alert admin/owner on new account
create or alter trigger Alert_NewAccount
on Kunder
after insert
	as
	begin

print 'Nytt konto har skapats på databasen.'
select top 1 Kunder.Förnamn, Kunder.Efternamn, Kunder.Telefon, Kunder.Mail,
Städer.Namn as Stad,
Länder.Namn as Land,
Postnummer.Postnr,
Betalkort.Namn as Kort_Ägare
from Kunder, Städer, Länder, Postnummer, Betalkort
where 
Städer.Id = (select Adresser.Städer_Id from Adresser where Adresser.Id = Kunder.Adresser_Id) and 
Länder.Id = (select Adresser.Länder_Id from Adresser where Adresser.Id = Kunder.Adresser_Id) and
Postnummer.Id = (select Adresser.Postnummer_Id from Adresser where Adresser.Id = Kunder.Adresser_Id) and
Betalkort.Id = Kunder.Betalkort_Id
order by kunder.id desc

	end

go
