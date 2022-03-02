use Hotel_Isaac_Db 

GO


-- Create new address
CREATE OR ALTER PROCEDURE Add_Address @Country nvarchar(255), @City nvarchar(255), @Postal_Address varchar(10), @Street nvarchar(255)
AS
if not exists(
	select * from Länder where Namn = @Country)
	begin
	insert into Länder (Namn) select @Country
		end

	if not exists(
	select * from Städer where Namn = @City)
	begin
	insert into Städer (Namn) select @City
		end

	if not exists(
	select * from Postnummer where Postnr = @Postal_Address)
	begin
	insert into Postnummer (Postnr) select @Postal_Address
		end

insert into Adresser(Postnummer_Id, Städer_Id, Länder_Id, Gatuadress) 
values(
	(select Id from Postnummer where Postnr = @Postal_Address),
	(select Id from Städer where Städer.Namn = @City),
	(select Id from Länder where Länder.Namn = @Country),
	@Street
)
GO


-- Add new contact person if not exist
CREATE OR ALTER PROCEDURE Add_Contact_Person @FirstName nvarchar(255), @LastName nvarchar(255), @PhoneNumber varchar(30), @Mail nvarchar(255)
AS
if not exists(
	select * from Kontaktpersoner where Förnamn = @FirstName and Efternamn = @LastName and Telefon = @PhoneNumber and Mail = @Mail)
	begin
		insert into Kontaktpersoner(Förnamn, Efternamn, Telefon, Mail) 
		select @FirstName, @LastName, @PhoneNumber, @Mail
		end

GO

-- Create new payment card if not exist
CREATE OR ALTER PROCEDURE Add_Payment_Card @Name nvarchar(255), @Number nvarchar(255), @Expiration datetime2(0), @CVC char(3)
AS
if not exists(
	select * from Betalkort where Namn = @Name and Kortnummer = @Number and Giltighetsdatum = @Expiration and CVC = @CVC)
		begin
		insert into Betalkort(Namn, Kortnummer, Giltighetsdatum, CVC) 
		select @Name, @Number, @Expiration, @CVC
		end
GO


-- Create account
CREATE OR ALTER PROCEDURE Add_User 
	@FirstName nvarchar(255),
	@LastName nvarchar(255),
	@PhoneNumber varchar(30),
	@Mail nvarchar(255),

	@Country nvarchar(255),
	@City nvarchar(255),
	@Postal_Address varchar(10),
	@Street nvarchar(255),

	@Card_Name nvarchar(255),
	@Card_Number nvarchar(255),
	@Card_Expiration datetime2(0),
	@Card_CVC char(3),

	@Contact_FirstName nvarchar(255),
	@Contact_LastName nvarchar(255),
	@Contact_PhoneNumber varchar(30),
	@Contact_Mail nvarchar(255)
AS

-- create required address, contact person, payment card first
exec Add_Address @Country, @City,@Postal_Address, @Street;
exec Add_Contact_Person @Contact_FirstName, @Contact_LastName, @Contact_PhoneNumber, @Contact_Mail
exec Add_Payment_Card @Card_Name, @Card_Number, @Card_Expiration, @Card_CVC

-- create  user + link keys
insert into Kunder(Förnamn, Efternamn, Telefon, Mail, Adresser_Id, Kontaktpersoner_Id, Betalkort_Id)
values( 
	@FirstName, 
	@LastName, 
	@PhoneNumber, 
	@Mail,
	-- Addresser_ID fk
	(select top 1 Id from Adresser where 
		(select Namn from Städer where Id = Städer_Id ) = @City and 
		(select Namn from Länder where Id = Länder_Id ) = @Country and 
		(select Postnr from Postnummer where Id = Postnummer_Id ) = @Postal_Address and 
		Gatuadress = @Street),
	-- Kontaktpersoner fk
	(select top 1 Id from Kontaktpersoner where 
			@Contact_FirstName = Kontaktpersoner.Förnamn and
			@Contact_LastName = Kontaktpersoner.Efternamn and
			@Contact_PhoneNumber = Kontaktpersoner.Telefon and
			@Contact_Mail = Kontaktpersoner.Mail),
	-- Betalkort fk
	(select top 1 Id  from Betalkort where 
			@Card_Name = Betalkort.Namn and
			@Card_Number= Betalkort.Kortnummer and
			@Card_Expiration = Betalkort.Giltighetsdatum and
			@Card_CVC = Betalkort.CVC)
			)
GO

