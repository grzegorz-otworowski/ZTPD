--zadanie 1
create type samochod as object (
marka  VARCHAR2(20),
model VARCHAR2(20),
kilometry NUMBER,
data_produkcji DATE,
cena NUMBER);

desc samochod;

create table samochody of samochod;

insert into samochody values (new samochod('fiat','brava',60000,DATE'1999-11-30',25000));
insert into samochody values (new samochod('ford','mondeo',80000,DATE'1997-05-10',45000));
insert into samochody values (new samochod('mazda','323',12000,DATE'2000-09-22',52000));

select * from samochody;

--zadanie 2

create table wlasciciele (imie VARCHAR2(100),nazwisko VARCHAR2(100), auto samochod);

insert into wlasciciele values ('jan','kowalski',new samochod('fiat','seicento',30000,DATE'2010-12-02',19500));
insert into wlasciciele values ('adam','nowak', new samochod('opel','astra',34000,DATE'2009-06-01',33700));

select * from wlasciciele;

alter type samochod replace as object (
marka  VARCHAR2(20),
model VARCHAR2(20),
kilometry NUMBER,
data_produkcji DATE,
cena NUMBER,
MEMBER FUNCTION wartosc RETURN NUMBER);

--zadanie 3

create or replace type body samochod as
member function wartosc return number is
begin
return round(cena * power(0.9, extract(year from current_date) - extract(year from data_produkcji)));
end;
end;

select s.marka, s.cena, s.wartosc() from samochody s;

--zadanie 4

alter type samochod add map member function odwzoruj
return number cascade including table data;

create or replace type body samochod as
    member function wartosc return number is
    begin
        return round(cena * power(0.9, extract(year from current_date) - extract(year from data_produkcji)));
    end;
    map member function odwzoruj return number is
    begin
        return extract(year from current_date) - extract(year from data_produkcji) + round(kilometry/10000);
    end;
end;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

--zadanie 5

drop table samochody;
drop table wlasciciele;
drop type samochod;

create type Twlasciciel as object (
imie  VARCHAR2(20),
nazwisko VARCHAR2(20));

create table wlasciciele of Twlasciciel;

create type samochod as object (
    marka  VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER,
    wlasciciel REF Twlasciciel,
    MEMBER FUNCTION wartosc RETURN NUMBER,
    MEMBER FUNCTION odwzoruj RETURN NUMBER
);

create table samochody of samochod;

insert into wlasciciele values (new twlasciciel('Jan','Kowalski'));
insert into wlasciciele values (new twlasciciel('Anna','Kowalska'));

insert into samochody values (new samochod('fiat','brava',60000,DATE'1999-11-30',25000,null));
insert into samochody values (new samochod('ford','mondeo',80000,DATE'1997-05-10',45000,null));
insert into samochody values (new samochod('mazda','323',12000,DATE'2000-09-22',52000,null));

update samochody s set s.wlasciciel = (
    select ref(w) from wlasciciele w
    where w.imie = 'Jan' );

SET SERVEROUTPUT ON

--zad 6

DECLARE
TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
moje_przedmioty(1) := 'MATEMATYKA';
moje_przedmioty.EXTEND(9);
FOR i IN 2..10 LOOP
moje_przedmioty(i) := 'PRZEDMIOT_' || i;
END LOOP;
FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
END LOOP;
moje_przedmioty.TRIM(2);
FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
moje_przedmioty.EXTEND();
moje_przedmioty(9) := 9;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
moje_przedmioty.DELETE();
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- zad 7

DECLARE
TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
moje_ksiazki(1) := 'HARRY POTTER';
moje_ksiazki.EXTEND(9);
FOR i IN 2..10 LOOP
moje_ksiazki(i) := 'KSIAZKA' || i;
END LOOP;
FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
END LOOP;
moje_ksiazki.TRIM(2);
FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
moje_ksiazki.EXTEND();
moje_ksiazki(9) := 9;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
moje_ksiazki.DELETE();
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

--zad 8

DECLARE
TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
moi_wykladowcy.EXTEND(2);
moi_wykladowcy(1) := 'MORZY';
moi_wykladowcy(2) := 'WOJCIECHOWSKI';
moi_wykladowcy.EXTEND(8);
FOR i IN 3..10 LOOP
moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
END LOOP;
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END LOOP;
moi_wykladowcy.TRIM(2);
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END LOOP;
moi_wykladowcy.DELETE(5,7);
DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
IF moi_wykladowcy.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END IF;
END LOOP;
moi_wykladowcy(5) := 'ZAKRZEWICZ';
moi_wykladowcy(6) := 'KROLIKOWSKI';
moi_wykladowcy(7) := 'KOSZLAJDA';
FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
IF moi_wykladowcy.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
END IF;
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

--zad 9

DECLARE
TYPE t_miesiace IS TABLE OF VARCHAR2(12);
miesiace t_miesiace:= t_miesiace();
BEGIN
miesiace.EXTEND(12);
miesiace(1) := 'STYCZEN';
miesiace(2) := 'LUTY';
FOR i IN 3..12 LOOP
miesiace(i) := 'MIESIAC_' || i;
END LOOP;
FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(miesiace(i));
END LOOP;
miesiace.TRIM(3);
FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(miesiace(i));
END LOOP;
miesiace.DELETE(5,7);
DBMS_OUTPUT.PUT_LINE('Limit: ' || miesiace.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || miesiace.COUNT());
FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
IF miesiace.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(miesiace(i));
END IF;
END LOOP;
miesiace(5) := 'MAJ';
miesiace(6) := 'CZERWIEC';
miesiace(7) := 'LIPIEC';
FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
IF miesiace.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(miesiace(i));
END IF;
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || miesiace.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || miesiace.COUNT());
END;

--zad 10

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
nazwa VARCHAR2(50),
kraj VARCHAR2(30),
jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
numer NUMBER,
egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

--zad 11

CREATE TYPE lista_zakupow AS TABLE OF VARCHAR2(20);

CREATE TYPE koszyk_produktow AS OBJECT (
nazwa VARCHAR2(30),
zakupy lista_zakupow);

CREATE TABLE koszyki_produktow OF koszyk_produktow
NESTED TABLE zakupy STORE AS tab_zakupy;

INSERT INTO koszyki_produktow VALUES
(koszyk_produktow('S£ODYCZE',lista_zakupow('CZEKOLADA','KASZTANKI','BATON')));

INSERT INTO koszyki_produktow VALUES
(koszyk_produktow('NABIA£',lista_zakupow('MLEKO','SER BIA£Y')));

SELECT kp.nazwa, z.*
FROM koszyki_produktow kp, TABLE(kp.zakupy) z;

SELECT z.*
FROM koszyki_produktow kp, TABLE (kp.zakupy) z;

SELECT column_value FROM (SELECT kp.zakupy FROM koszyki_produktow kp WHERE nazwa='NABIA£');

DELETE FROM TABLE (SELECT kp.zakupy FROM koszyki_produktow kp WHERE nazwa='NABIA£') e
WHERE e.column_value = 'MLEKO';

DELETE TABLE(SELECT kp.zakupy FROM koszyki_produktow kp WHERE kp.nazwa='NABIA£') z 
WHERE z.column_value = 'MLEKO';

--zad 12
CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;

CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;

CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;

DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;

-- zad 13

CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
 
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
 
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;

DECLARE
 KrolLew lew := lew('LEW',4);
-- InnaIstota istota := istota('JAKIES ZWIERZE'); ERROR NOT INSTANTIABLE
BEGIN
 DBMS_OUTPUT.PUT_LINE(KrolLew.poluj('antylopa'));
END;

-- zad 14
DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

-- zad 15

CREATE TABLE instrumenty OF instrument;

INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa'));
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );

SELECT i.nazwa, i.graj() FROM instrumenty i;

-- zad 16

CREATE TABLE PRZEDMIOTY (
 NAZWA VARCHAR2(50),
 NAUCZYCIEL NUMBER REFERENCES PRACOWNICY(ID_PRAC)
);

INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',100);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',100);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',110);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',110);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',120);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',120);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',130);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',140);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',140);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',140);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',150);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',150);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',160);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',160);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',170);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',180);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',180);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',190);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',200);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',210);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',220);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',220);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',230);

-- zad 17

CREATE TYPE ZESPOL AS OBJECT (
 ID_ZESP NUMBER,
 NAZWA VARCHAR2(50),
 ADRES VARCHAR2(100)
);

-- zad 18

CREATE OR REPLACE VIEW ZESPOLY_V OF ZESPOL
WITH OBJECT IDENTIFIER(ID_ZESP)
AS SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY;

-- zad 19

CREATE TYPE PRZEDMIOTY_TAB AS TABLE OF VARCHAR2(100);

CREATE TYPE PRACOWNIK AS OBJECT (
 ID_PRAC NUMBER,
 NAZWISKO VARCHAR2(30),
 ETAT VARCHAR2(20),
 ZATRUDNIONY DATE,
 PLACA_POD NUMBER(10,2),
 MIEJSCE_PRACY REF ZESPOL,
 PRZEDMIOTY PRZEDMIOTY_TAB,
 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY PRACOWNIK AS
 MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER IS
 BEGIN
 RETURN PRZEDMIOTY.COUNT();
 END ILE_PRZEDMIOTOW;
END;

-- zad 20

CREATE OR REPLACE VIEW PRACOWNICY_V OF PRACOWNIK
WITH OBJECT IDENTIFIER (ID_PRAC)
AS SELECT ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,
 MAKE_REF(ZESPOLY_V,ID_ZESP),
 CAST(MULTISET( SELECT NAZWA FROM PRZEDMIOTY WHERE NAUCZYCIEL=P.ID_PRAC ) AS
PRZEDMIOTY_TAB )
FROM PRACOWNICY P;

-- zad 21

SELECT *
FROM PRACOWNICY_V;

SELECT P.NAZWISKO, P.ETAT, P.MIEJSCE_PRACY.NAZWA
FROM PRACOWNICY_V P;

SELECT P.NAZWISKO, P.ILE_PRZEDMIOTOW()
FROM PRACOWNICY_V P;

SELECT *
FROM TABLE( SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE NAZWISKO='WEGLARZ' );

SELECT NAZWISKO, CURSOR( SELECT PRZEDMIOTY
FROM PRACOWNICY_V
WHERE ID_PRAC=P.ID_PRAC)
FROM PRACOWNICY_V P;

-- zad 22

CREATE TABLE PISARZE (
 ID_PISARZA NUMBER PRIMARY KEY,
 NAZWISKO VARCHAR2(20),
 DATA_UR DATE );
 
 CREATE TABLE KSIAZKI (
 ID_KSIAZKI NUMBER PRIMARY KEY,
 ID_PISARZA NUMBER NOT NULL REFERENCES PISARZE,
 TYTUL VARCHAR2(50),
 DATA_WYDANIA DATE);
 
INSERT INTO PISARZE VALUES(10,'SIENKIEWICZ',DATE '1880-01-01');
INSERT INTO PISARZE VALUES(20,'PRUS',DATE '1890-04-12');
INSERT INTO PISARZE VALUES(30,'ZEROMSKI',DATE '1899-09-11');

INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA) 
VALUES(10,10,'OGNIEM I MIECZEM',DATE '1990-01-05');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA)
VALUES(20,10,'POTOP',DATE '1975-12-09');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA) 
VALUES(30,10,'PAN WOLODYJOWSKI',DATE '1987-02-15');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA)
VALUES(40,20,'FARAON',DATE '1948-01-21');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA)
VALUES(50,20,'LALKA',DATE '1994-08-01');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIA)
VALUES(60,30,'PRZEDWIOSNIE',DATE '1938-02-02');
--
CREATE TYPE KSIAZKI_TAB AS TABLE OF VARCHAR(100);

CREATE TYPE PISARZ AS OBJECT(
 ID_PISARZA NUMBER,
 NAZWISKO VARCHAR2(20),
 DATA_UR DATE,
 KSIAZKI KSIAZKI_TAB,
 MEMBER FUNCTION LICZBA_KSIAZEK RETURN NUMBER);
 
CREATE TYPE KSIAZKA AS OBJECT(
 ID_KSIAZKI NUMBER,
 ID_PISARZA NUMBER,
 TYTUL VARCHAR2(50),
 DATA_WYDANIA DATE,
 MEMBER FUNCTION WIEK RETURN NUMBER);

CREATE OR REPLACE TYPE BODY PISARZ AS
    MEMBER FUNCTION LICZBA_KSIAZEK RETURN NUMBER IS
    BEGIN
        RETURN KSIAZKI.COUNT();
    END LICZBA_KSIAZEK;
END;

CREATE OR REPLACE TYPE BODY KSIAZKA AS
    MEMBER FUNCTION WIEK RETURN NUMBER IS
    BEGIN
        RETURN ROUND(MONTHS_BETWEEN(SYSDATE,DATA_WYDANIA)/12);
    END WIEK;
END;

CREATE OR REPLACE VIEW KSIAZKI_V OF KSIAZKA
WITH OBJECT IDENTIFIER (ID_KSIAZKI)
AS SELECT ID_KSIAZKI, ID_PISARZA, TYTUL, DATA_WYDANIA
    FROM KSIAZKI K;

CREATE OR REPLACE VIEW PISARZE_V OF PISARZ
WITH OBJECT IDENTIFIER (ID_PISARZA)
AS SELECT ID_PISARZA,NAZWISKO,DATA_UR,
    CAST(MULTISET(SELECT TYTUL FROM KSIAZKI K WHERE K.ID_PISARZA=P.ID_PISARZA) AS
    KSIAZKI_TAB) FROM PISARZE P;

SELECT *
FROM PISARZE_V;

SELECT *
FROM KSIAZKI_V;

SELECT P.NAZWISKO,P.LICZBA_KSIAZEK()
FROM PISARZE_V P;

SELECT K.TYTUL, K.DATA_WYDANIA, K.WIEK()
FROM KSIAZKI_V K;
-- zad 23

CREATE OR REPLACE TYPE AUTO AS OBJECT (
 MARKA VARCHAR2(20),
 MODEL VARCHAR2(20),
 KILOMETRY NUMBER,
 DATA_PRODUKCJI DATE,
 CENA NUMBER(10,2),
 MEMBER FUNCTION WARTOSC RETURN NUMBER
) NOT FINAL;

CREATE OR REPLACE TYPE BODY AUTO AS
 MEMBER FUNCTION WARTOSC RETURN NUMBER IS
    WIEK NUMBER;
    WARTOSC NUMBER;
 BEGIN
    WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
    WARTOSC := CENA - (WIEK * 0.1 * CENA);
    IF (WARTOSC < 0) THEN
        WARTOSC := 0;
     END IF;
     RETURN WARTOSC;
    END WARTOSC;
END;

CREATE TABLE AUTA OF AUTO;

INSERT INTO AUTA VALUES (AUTO('FIAT','BRAVA',60000,DATE '1999-11-30',25000));
INSERT INTO AUTA VALUES (AUTO('FORD','MONDEO',80000,DATE '1997-05-10',45000));
INSERT INTO AUTA VALUES (AUTO('MAZDA','323',12000,DATE '2000-09-22',52000));
--
CREATE TYPE AUTO_OSOBOWE UNDER AUTO(
    MIEJSCA NUMBER,
    KLIMATYZACJA VARCHAR(3),
    OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);
CREATE TYPE AUTO_CIEZAROWE UNDER AUTO(
    MAX_LADOWNOSC NUMBER,
    OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY AUTO_OSOBOWE AS
OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
    WIEK NUMBER;
    WARTOSC NUMBER;
 BEGIN
    WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
    WARTOSC := CENA - (WIEK * 0.1 * CENA);
    IF (WARTOSC < 0) THEN
        WARTOSC := 0;
    ELSE
        IF (KLIMATYZACJA = 'TAK') THEN
            WARTOSC := WARTOSC * 2;
        END IF;
     END IF;
     RETURN WARTOSC;
    END WARTOSC;
END;

CREATE TYPE BODY AUTO_CIEZAROWE AS
OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
    WIEK NUMBER;
    WARTOSC NUMBER;
 BEGIN
    WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
    WARTOSC := CENA - (WIEK * 0.1 * CENA);
    IF (WARTOSC < 0) THEN
        WARTOSC := 0;
     ELSE
        IF (MAX_LADOWNOSC > 10) THEN
            WARTOSC := WARTOSC * 2;
        END IF;
     END IF;
     RETURN WARTOSC;
    END WARTOSC;
END;

INSERT INTO AUTA VALUES (AUTO_OSOBOWE('BMW','iX3',30000,'2015-05-21',210000,5,'TAK'));
INSERT INTO AUTA VALUES (AUTO_OSOBOWE('FIAT','126p',80000,'1981-04-11',7000,5,'NIE'));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('DAV','CF 85',30000,'2008-01-24',78000,12));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('IVECO','STRALIS',40000,'2014-07-14',42000,8));

SELECT MARKA, A.WARTOSC() FROM AUTA A;

