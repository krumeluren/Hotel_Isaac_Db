CREATE DATABASE Hotel_Isaac_Db

go

USE Hotel_Isaac_Db

go



CREATE TABLE [Länder] (
  [Id] int identity,
  [Namn] nvarchar(255),
  PRIMARY KEY ([Id])
);

CREATE TABLE [Städer] (
  [Id] int identity,
  [Namn] nvarchar(255),
  PRIMARY KEY ([Id]),
);

CREATE TABLE [Postnummer] (
  [Id] int identity,
  [Postnr] varchar(10),
  PRIMARY KEY ([Id]),
);


CREATE TABLE [Adresser] (
  [Id] int identity,
  [Postnummer_Id] int,
  [Städer_Id] int,
  [Länder_Id] int,
  [Gatuadress] nvarchar(255),
  PRIMARY KEY ([Id]),
  CONSTRAINT [FK_Adresser.Länder_Id]
    FOREIGN KEY ([Länder_Id])
      REFERENCES [Länder]([Id]),
  CONSTRAINT [FK_Adresser.Städer_Id]
    FOREIGN KEY ([Städer_Id])
      REFERENCES [Städer]([Id]),
  CONSTRAINT [FK_Adresser.Postnummer_Id]
    FOREIGN KEY ([Postnummer_Id])
      REFERENCES [Postnummer]([Id])
);

CREATE TABLE [Kontaktpersoner] (
  [Id] int identity,
  [Förnamn] nvarchar(255),
  [Efternamn] nvarchar(255),
  [Telefon] varchar(30),
  [Mail] nvarchar(255),
  PRIMARY KEY ([Id])
);


CREATE TABLE [Betalkort] (
  [Id] int identity,
  [Namn] nvarchar(255),
  [Kortnummer] varchar(255),
  [Giltighetsdatum] datetime2(0),
  [CVC] char(3),
  PRIMARY KEY ([Id])
);

CREATE TABLE [Kunder] (
  [Id] int identity,
  [Telefon] varchar(30),
  [Mail] nvarchar(255),
  [Adresser_Id] int,
  [Förnamn] nvarchar(255),
  [Efternamn] nvarchar(255),
  [Kontaktpersoner_Id] int,
  [Betalkort_Id] int,
  PRIMARY KEY ([Id]),
  CONSTRAINT [FK_Kunder.Adresser_Id]
    FOREIGN KEY ([Adresser_Id])
      REFERENCES [Adresser]([Id]),

  CONSTRAINT [FK_Kunder.Kontaktpersoner_Id]
    FOREIGN KEY ([Kontaktpersoner_Id])
      REFERENCES [Kontaktpersoner]([Id]),

  CONSTRAINT [FK_Kunder.Betalkort_Id]
    FOREIGN KEY ([Betalkort_Id])
      REFERENCES [Betalkort]([Id])
);

CREATE TABLE [Noteringar] (
  [Id] int identity,
  [Kund_Betyg] int,
  [Kund_Text] nvarchar(255),
  PRIMARY KEY ([Id])
);

CREATE TABLE [Betalsätt] (
  [Id] int identity,
  [Namn] nvarchar(255),
  PRIMARY KEY ([Id])
);

CREATE TABLE [Bokningar] (
  [Id] int identity,
  [Kunder_Id] int,
  [Antal_Personer] int,
  [Total_Kostnad] smallmoney,
  [Noteringar_Id] int,
  [Betalsätt_Id] Int,
  [Bokningsdatum] datetime2(4),
  [Speciella_Önskemål] nvarchar(255),
  [Ankomst] datetime2(4),
  [Avfärd] datetime2(4),
  PRIMARY KEY ([Id]),
  CONSTRAINT [FK_Bokningar.Kunder_Id]
    FOREIGN KEY ([Kunder_Id])
      REFERENCES [Kunder]([Id]),

  CONSTRAINT [FK_Bokningar.Betalsätt_Id]
    FOREIGN KEY ([Betalsätt_Id])
      REFERENCES [Betalsätt]([Id]),

  CONSTRAINT [FK_Bokningar.Noteringar_Id]
    FOREIGN KEY ([Noteringar_Id])
      REFERENCES [Noteringar]([Id])
);



CREATE TABLE [Rumstyp] (
  [Id] int identity,
  [Namn] nvarchar(255),
  [Max_Antal_Personer] int,
  PRIMARY KEY ([Id])
);

CREATE TABLE [Extra_Kostnader] (
  [Id] int identity,
  [Minibar] smallmoney,
  [Frukost] smallmoney,
  PRIMARY KEY ([Id])
);

CREATE TABLE [Rum] (
  [Id] int identity,
  [Rumstyp_Id] int,
  [Rumsnummer] int,
  [Bas_Pris] smallmoney,
  [Rabatt] smallmoney,
  [Extra_Kostnader_Id] int,
  PRIMARY KEY ([Id]),

  CONSTRAINT [FK_Rum.Rumstyp_Id]
    FOREIGN KEY ([Rumstyp_Id])
      REFERENCES [Rumstyp]([Id]),

  CONSTRAINT [FK_Rum.Extra_Kostnader_Id]
    FOREIGN KEY ([Extra_Kostnader_Id])
      REFERENCES [Extra_Kostnader]([Id])
);




CREATE TABLE [Extra_Bokningar] (
  [Id] int identity,
  [Inkludera_Frukost] bit,
  [Inkludera_Minibar] bit,
  PRIMARY KEY ([Id])
);

CREATE TABLE [Bokade_Dagar] (
  [Id] int identity,
  [Bokningar_Id] int,
  [Extra_Bokningar_Id] int,
  [Rum_Id] int,
  [Startdatum] datetime2(4),
  [Slutdatum] datetime2(4),
  [Antal_Extrabäddar] int,

  PRIMARY KEY ([Id]),
  CONSTRAINT [FK_Bokade_Dagar.Rum_Id]
    FOREIGN KEY ([Rum_Id])
      REFERENCES [Rum]([Id]),

  CONSTRAINT [FK_Bokade_Dagar.Bokningar_Id]
    FOREIGN KEY ([Bokningar_Id])
      REFERENCES [Bokningar]([Id]),

  CONSTRAINT [FK_Bokade_Dagar.Extra_Bokningar_Id]
    FOREIGN KEY ([Extra_Bokningar_Id])
      REFERENCES [Extra_Bokningar]([Id])
);


CREATE TABLE [Ansvarig_Personal] (
  [Id] int identity,
  [Förnamn] nvarchar(255),
  [Efternamn] nvarchar(255),
  [Telefon] varchar(30),
  [Mail] nvarchar(255),
  PRIMARY KEY ([Id])
);


