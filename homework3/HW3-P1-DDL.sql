--  Homework 3 - Solution to Part 1
--  Copyright (C) 2019-2020, Björn Þór Jónsson

-- 1. People

CREATE TABLE People (
    ID INT,
    Name VARCHAR NOT NULL,
    Address VARCHAR NOT NULL,
    Phone INT NOT NULL,
    DOB DATE NOT NULL,
    DOD DATE NULL,
    PRIMARY KEY (ID)
);

-- 2. Enemies and Members

-- Does not capture covering constraint

CREATE TABLE Enemy (
    ID INT REFERENCES People,
    PRIMARY KEY (ID)
);

CREATE TABLE Member (
    ID INT REFERENCES People,
    Start_date DATE NOT NULL,
    PRIMARY KEY (ID)
);

-- 3. Assets of Members

CREATE TABLE Asset (
    ID INT REFERENCES Member,
    Name VARCHAR NOT NULL,
    Detail VARCHAR NOT NULL,
    Uses VARCHAR NOT NULL,
    PRIMARY KEY (ID, Name)
);

-- 4. Opponents of Enemies

CREATE TABLE Opposes (
    MID INT REFERENCES Member(ID),
    EID INT REFERENCES Enemy(ID),
    Start_Date DATE NOT NULL,
    End_Date DATE NULL,
    PRIMARY KEY (MID, EID)
);

-- 5. Linkings 

CREATE TABLE Linking (
    ID INT,
    Name VARCHAR(50) NOT NULL,
    Type CHAR(1) NOT NULL,
    Description VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);

-- Does not capture participation requirements

CREATE TABLE Participate (
    LID INT REFERENCES Linking(ID),
    PID INT REFERENCES People(ID),
    PRIMARY KEY (LID, PID)
);

-- 6. Roles

CREATE TABLE Role (
    ID INT,
    Title VARCHAR NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE (Title)
);

CREATE TABLE Serve_in (
    RID INT REFERENCES Role (ID),
    MID INT REFERENCES Member (ID),
    Start_date DATE NOT NULL,
    End_date DATE NOT NULL,
    Salary INTEGER NOT NULL,
    PRIMARY KEY (RID, MID)
);

-- 7. Parties

CREATE TABLE Party (
    ID INT,
    Name VARCHAR NOT NULL,
    Country VARCHAR NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE (Name, Country)
);

CREATE TABLE Monitor (
    PartyID INT REFERENCES Party(ID),
    MonitorID INT NOT NULL REFERENCES Member(ID),
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (PartyID, start_date)
);

-- 8. Sponsors

CREATE TABLE Sponsor (
    ID INT,
    Name VARCHAR NOT NULL,
    Address VARCHAR NOT NULL,
    Industry VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);

-- 9. Sponsorships

CREATE TABLE Sponsors (
    -- These columns for the sponsorships
    SID INT REFERENCES Sponsor (ID),
    MID INT REFERENCES Member (ID),
    SDate DATE,
    SAmount INT NOT NULL,
    SPayback VARCHAR NOT NULL,
    PRIMARY KEY (SID, MID, SDate),

-- 10. Sponsorships reviews

    -- These columns for the Reviews relationship
    -- Note that we are still working on the Sponsors table
    -- Be careful about the NULLs here!
    RID INT NOT NULL REFERENCES Member (ID),
    RDate DATE NOT NULL,
    RGrade INT NULL,
    CHECK ((RGrade >= 1) AND (RGrade <=10))
);
