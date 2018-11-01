CREATE DATABASE PDN;
\c PDN;
--P1

CREATE TABLE Sailor (
	Sid INTEGER, 
	Sname VARCHAR(20), 
	Rating INTEGER, 
	Age INTEGER,
	PRIMARY KEY (Sid)
);

CREATE TABLE Boat(
	Bid INTEGER, 
	Bname VARCHAR(15), 
	Color VARCHAR(15),
	PRIMARY KEY (Bid)
);

CREATE TABLE Reserves(
	Sid INTEGER, 
	Bid INTEGER, 
	Day VARCHAR(10),
	FOREIGN KEY (Sid) REFERENCES Sailor(Sid),
	FOREIGN KEY (Bid) REFERENCES Boat(Bid)
);

INSERT INTO Sailor VALUES (22,   'Dustin',       7,      45);
INSERT INTO Sailor VALUES (29,   'Brutus',       1,      33);
INSERT INTO Sailor VALUES (31,   'Lubber',       8,      55);
INSERT INTO Sailor VALUES (32,   'Andy',         8,      25);
INSERT INTO Sailor VALUES (58,   'Rusty',        10,     35);
INSERT INTO Sailor VALUES (64,   'Horatio',      7,      35);
INSERT INTO Sailor VALUES (71,   'Zorba',        10,     16);
INSERT INTO Sailor VALUES (74,   'Horatio',      9,      35);
INSERT INTO Sailor VALUES (85,   'Art',          3,      25);
INSERT INTO Sailor VALUES (95,   'Bob',          3,      63);

INSERT INTO Boat VALUES (101,	'Interlake',	'blue');
INSERT INTO Boat VALUES (102,	'Sunset',	'red');
INSERT INTO Boat VALUES (103,	'Clipper',	'green');
INSERT INTO Boat VALUES (104,	'Marine',	'red');

INSERT INTO Reserves VALUES (22,	101,	'Monday');
INSERT INTO Reserves VALUES (22,	102,	'Tuesday');
INSERT INTO Reserves VALUES (22,	103,	'Wednesday');
INSERT INTO Reserves VALUES (31,	102,	'Thursday');
INSERT INTO Reserves VALUES (31,	103,	'Friday');
INSERT INTO Reserves VALUES (31,    104,	'Saturday');
INSERT INTO Reserves VALUES (64,	101,	'Sunday');
INSERT INTO Reserves VALUES (64,	102,	'Monday');
INSERT INTO Reserves VALUES (74,	102,	'Saturday');

--P3
--a
SELECT Rating
FROM Sailor;

--b
SELECT Bid, Color
FROM Boat;

--c
SELECT Sname
FROM Sailor S
WHERE S.Age>=15 AND S.Age<=30;

--d
SELECT Bname
FROM Boat B
WHERE B.Bid IN (SELECT Bid
			  FROM Reserves R
			  WHERE R.day = 'Saturday' OR R.day = 'Sunday') ;

--e
SELECT Sname
FROM Sailor S, (SELECT Bid FROM Boat B WHERE B.color= 'red')C
WHERE S.Sid IN (SELECT Sid FROM Reserves R WHERE R.Bid = C.Bid)

INTERSECT

SELECT Sname
FROM Sailor S, (SELECT Bid FROM Boat B WHERE B.color= 'green')C
WHERE S.Sid IN (SELECT Sid FROM Reserves R WHERE R.Bid = C.Bid);

--f

SELECT Sname
FROM Sailor S, (SELECT Bid FROM Boat B WHERE B.color= 'red')C
WHERE S.Sid IN (SELECT Sid FROM Reserves R WHERE R.Bid = C.Bid)

EXCEPT

SELECT Sname
FROM Sailor S, (SELECT Bid FROM Boat B WHERE B.color= 'green')C
WHERE S.Sid IN (SELECT Sid FROM Reserves R WHERE R.Bid = C.Bid)

EXCEPT

SELECT Sname
FROM Sailor S, (SELECT Bid FROM Boat B WHERE B.color= 'blue')C
WHERE S.Sid IN (SELECT Sid FROM Reserves R WHERE R.Bid = C.Bid);

--g
SELECT Sid
FROM Sailor S
WHERE S.Sid IN (SELECT R1.Sid FROM Reserves R1, Reserves R2 WHERE R1.Sid = R2.Sid AND R1.Bid <> R2.Bid);

--h
SELECT Sid
FROM Sailor
WHERE Sid NOT IN (SELECT DISTINCT Sid FROM Reserves);

--i
SELECT DISTINCT R1.Sid, R2.Sid
FROM Reserves R1, Reserves R2
WHERE R1.day = 'Saturday' AND R2.day = 'Saturday' AND R1.Sid <> R2.Sid AND R1.Sid > R2.Sid;

--j
SELECT DISTINCT R1.Bid
FROM Reserves R1, Reserves R2
WHERE R1.Bid = R2.Bid AND R1.Sid = R2.Sid AND R1.day = R2.day

EXCEPT

SELECT DISTINCT R1.Bid
FROM Reserves R1, Reserves R2
WHERE R1.Bid = R2.Bid AND R1.Sid <> R2.Sid;


--P2
--Insert into Reserves which will succeed as Sid=71 and Bid=101 exist in Sailor and Boat respectively
INSERT INTO Reserves VALUES (71,	101,	'Tuesday');

--Insert into Reserves which will fail as Sid=10 doesn't exist in Sailor
INSERT INTO Reserves VALUES (10,	104,	'Tuesday');

--Insert into Reserves which will fail as Bid=105 doesn't exist in Boat
INSERT INTO Reserves VALUES (71,	105,	'Wednesday');

--Delete from Sailors which will succeed as Sid=32 isn't used in Reserves
DELETE FROM Sailor WHERE Sid = 32;

--Delete from Sailors which will fail as Sid=74 is used in Reserves
DELETE FROM Sailor WHERE Sid = 74;

--Delete from Boat which will fail as Bid=101 is used in Reserves
DELETE FROM Boat WHERE Bid = 101;

--Insert into Boat Bid=105 and then Delete from Boat where Bid=105 which will succeed as we don't use it in Reserves
INSERT INTO Boat VALUES (105,	'Poseidon',	'blue');
DELETE FROM Boat WHERE Bid = 105;

--However now if you drop all the key constraints from the tables, then all the insertions and deletes will start working
ALTER TABLE Reserves DROP CONSTRAINT reserves_sid_fkey;
ALTER TABLE Reserves DROP CONSTRAINT reserves_bid_fkey;
ALTER TABLE Sailor DROP CONSTRAINT sailor_pkey;
ALTER TABLE Boat DROP CONSTRAINT boat_pkey;

INSERT INTO Reserves VALUES (10,	104,	'Tuesday');
INSERT INTO Reserves VALUES (71,	105,	'Wednesday');
DELETE FROM Sailor WHERE Sid = 74;
DELETE FROM Boat WHERE Bid = 101;
\c postgres;
DROP DATABASE PDN;