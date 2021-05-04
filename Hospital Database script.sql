create database Hospital
go

use Hospital
go

create table administrator(
	admin_ID int not null primary key,
	ime nvarchar(30),
	prezime nvarchar(30),
	datum_kreiranja datetime,
	datum_modifikovanja datetime
)

create table doktor(
	doktor_ID int not null primary key,
	ime nvarchar(20),
	odjel_ID int,
	prezime nvarchar(20),
	jbm nvarchar(14),
	adresa nvarchar(20),
	datum_rodjenja date,
	telefon nvarchar(15),
	email nvarchar(40),
	spol_ID int,
	nadredjeni_ID int,
	grad_prebivalista_ID int,
	datum_kreiranja datetime,
	admin_ID int,
	constraint FK_doktor_doktor foreign key(nadredjeni_ID) references doktor(doktor_ID),
	constraint FK_doktor_admin foreign key(admin_ID) references administrator (admin_ID),
    constraint FK_doktor_odjel foreign key(odjel_ID) references odjel(odjel_ID),
	constraint FK_doktor_grad foreign key(grad_prebivalista_ID) references grad(grad_ID)
)




create table specijalizacija(
	specijalizacija_ID int not null primary key,
	doktor_ID int unique,
	naziv_specijalizacije nvarchar(40),
	datum_specijalizacije date,
	fakultet nvarchar(30),
	odsjek nvarchar(40),
	constraint FK_specijalizacija_doktor foreign key(doktor_ID) references doktor(doktor_ID)
)

create table odjel(
	odjel_ID int not null primary key,
	naziv_odjela nvarchar(20),
	sprat int,
	broj_doktora int,
	broj_sestara  int,
	broj_soba int
)


create table smjena(
	smjena_ID int not null identity(1,1) primary key,
	vrijeme_pocetka_smjene datetime,
	vrijeme_kraja_smjene datetime,
	bonus_na_platu float
)

create table doktorRadiSmjenu(
	doktor_ID int,
	smjena_ID int,
	datum_smjene date,
	constraint PK_doktorRadiSmjenu primary key(doktor_ID, smjena_ID, datum_smjene),
	constraint FK_doktorRadiSmjenu_Doktor foreign key(doktor_ID) references doktor(doktor_ID),
	constraint FK_doktorRadiSmjenu_smjena foreign key(smjena_ID) references smjena(smjena_ID)
)

create table spol(
	spol_ID int not null primary key,
	oznaka nvarchar(10)	
)

create table mSestra(
	mSestra_ID int not null primary key,
	ime nvarchar(20),
	odjel_ID int,
	prezime nvarchar(20),
	jbm nvarchar(14),
	adresa nvarchar(20),
	datum_rodjenja date,
	telefon nvarchar(15),
	email nvarchar(40),
	spol_ID int,
	grad_prebivalista_ID int,
	glavna_medicinska_sestra_ID int,
	datum_kreiranja datetime,
	datum_modifikovanja datetime,
	constraint FK_mSestra_Odjel foreign key(odjel_ID) references odjel(odjel_ID),
	constraint FK_mSestra_Spol foreign key(spol_ID) references spol(spol_ID),
	constraint FK_mSestra_gradPrebivalista foreign key(grad_prebivalista_ID) references grad(grad_ID),
	constraint FK_mSestra_glavnaSestra foreign key(glavna_medicinska_sestra_ID) references mSestra(mSestra_ID)
)



create table mSestraRadiSmjenu(
	m_sestra_ID int,
	smjena_ID int,
	datum_smjene date,
	constraint PK_mSestraRadiSmjenu primary key(m_sestra_ID, smjena_ID, datum_smjene),
	constraint FK_mSestraRadiSmjenu_mSestra foreign key(m_sestra_ID) references mSestra(mSestra_ID),
	constraint FK_mSestraRadiSmjenu_smjena foreign key(smjena_ID) references smjena(smjena_ID)
)

create table drzava(
	drzava_ID int not null primary key,
	naziv nvarchar(30),
	skracenica nvarchar(10)
)

create table grad(
	grad_ID int not null primary key,
	naziv nvarchar(30),
	ptt nvarchar(15),
	drzava_ID int,
	constraint FK_grad_drzava foreign key(drzava_ID) references drzava(drzava_ID)
)

create table lijek(
	lijek_ID int not null primary key,
	naziv_lijeka nvarchar(30),
	proizvodjac nvarchar(30),
	napomena nvarchar(150)
)

create table pacijent(
	pacijent_ID int not null primary key,
	ime nvarchar(20),
	prezime nvarchar(20),
	jbm nvarchar(14),
	adresa nvarchar(20),
	datum_rodjenja date,
	telefon nvarchar(15),
	email nvarchar(40),
	spol_ID int,
	grad_prebivalista_ID int,
	datum_kreiranja datetime,
	datum_modifikovanja datetime,
	constraint FK_pacijent_spol foreign key(spol_ID) references spol(spol_ID),
	constraint FK_pacijent_grad foreign key(grad_prebivalista_ID) references grad(grad_ID)
)

create table pregled(
	pregled_ID int not null,
	doktor_ID int,
	pacijent_ID int,
	mSestra_ID int,
	vrijeme_pocetka_pregleda time,
	vrijeme_kraja_pregleda time,
	constraint PK_pregled primary key(pregled_ID,doktor_ID,pacijent_ID),
	constraint FK_pregled_doktor foreign key(doktor_ID) references doktor(doktor_ID),
	constraint FK_pregled_mSestra foreign key(mSestra_ID) references mSestra(mSestra_ID),
	constraint FK_pregled_pacijent foreign key(pacijent_ID) references pacijent(pacijent_ID)
)


create table karton(
	karton_ID int not null primary key,
	pacijent_ID int,
	alergicnost nvarchar(100),
	krvna_grupa nvarchar(4),
	historija_bolesti nvarchar(100),
	constraint FK_karton_pacijent foreign key (pacijent_ID) references pacijent(pacijent_ID)
)

create table soba(
	soba_ID int not null primary key,
	odjel_ID int,
	sprat int,
	oznaka_sobe nvarchar(15),
	broj_kreveta int,
	constraint FK_soba_odjel foreign key(odjel_ID) references odjel(odjel_ID)
)


create table krevet(
	krevet_ID int not null primary key,
	soba_ID int,
	velicina_kreveta float,
	constraint FK_krevet_soba foreign key(soba_ID) references soba(soba_ID)
)

create table boravi(
	pacijent_ID int,
	krevet_ID int,
	datum_pocetka_boravka date,
	datum_zavrsetka_boravka date,
	constraint PK_boravi primary key(pacijent_ID,krevet_ID, datum_pocetka_boravka, datum_zavrsetka_boravka),
	constraint FK_boravi_pacijent foreign key(pacijent_ID) references pacijent(pacijent_ID),
	constraint FK_boravi_krevet foreign key (krevet_ID) references krevet(krevet_ID)
)


create table recept(
	recept_ID int not null primary key,
	pregled_ID int unique,
	pacijent_ID int,
	doktor_ID int,
	constraint FK_pregled foreign key(pregled_ID, doktor_ID, pacijent_ID) references pregled(pregled_ID,doktor_ID, pacijent_ID)
)





create table izdavanjeRecepta(
	recept_ID int,
	lijek_ID int,
	datum_izdavanja_lijeka date,
	doza nvarchar(10),
	nacin_upotrebe nvarchar(100),
	napomena nvarchar(100),
	constraint PK_izdavanjeRecepta primary key(recept_ID, lijek_ID),
	constraint FK_izdavanjeRecepta_recept foreign key(recept_ID) references recept(recept_ID),
	constraint FK_izdavanjeRecepta_lijek foreign key(lijek_ID) references lijek(lijek_ID)
)


create table audit_Doktor(
	audit_ID int not null identity(1,1),
	audit_date datetime not null default getdate(),
	korisnik sysname not null default SYSTEM_USER,
	[Promjene] xml not null,
	constraint PK_auditDoktor primary key clustered (audit_ID)
)


go
create trigger trigger_auditDoktor on dbo.doktor
after insert, update, delete
as
begin
insert into audit_Doktor([Promjene])
select
(
select 
	i.doktor_ID as [doktorID_new],
	d.doktor_ID as [doktorID_old],
	i.ime as [doktor_ime_new],
	d.ime as [doktor_ime_old],
	i.jbm as [jmb_new],
	d.jbm as [jmb_old],
	i.adresa as [adresa_new],
	d.adresa as [adresa_old],
	i.email as [email_new],
	d.email as [email_old]

from inserted i full outer join deleted d on
	 i.doktor_ID = d.doktor_ID
for
xml raw, root ('audit_Doktor')) as Promjene
end
go


