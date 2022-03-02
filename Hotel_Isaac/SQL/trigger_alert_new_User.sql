use Hotel_Isaac_Db
go

-- Trigger. Alert admin/owner on new account
create or alter trigger Alert_NewAccount
on Kunder
after insert
	as
	begin

print 'Nytt konto har skapats p� databasen.'
select top 1 Kunder.F�rnamn, Kunder.Efternamn, Kunder.Telefon, Kunder.Mail,
St�der.Namn as Stad,
L�nder.Namn as Land,
Postnummer.Postnr,
Betalkort.Namn as Kort_�gare
from Kunder, St�der, L�nder, Postnummer, Betalkort
where 
St�der.Id = (select Adresser.St�der_Id from Adresser where Adresser.Id = Kunder.Adresser_Id) and 
L�nder.Id = (select Adresser.L�nder_Id from Adresser where Adresser.Id = Kunder.Adresser_Id) and
Postnummer.Id = (select Adresser.Postnummer_Id from Adresser where Adresser.Id = Kunder.Adresser_Id) and
Betalkort.Id = Kunder.Betalkort_Id
order by kunder.id desc

	end

go
