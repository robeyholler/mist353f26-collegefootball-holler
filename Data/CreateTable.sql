/*CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;*/

if object_id('Stadium') is not null
    drop table Stadium;
if object_id('Team') is not null
    drop table Team;
if object_id('Game') is not null
    drop table Game;

go

CREATE table Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(50) NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState CHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField VARCHAR(20) NOT NULL,
    GameID INT NULL,
    constraint PK_Stadium PRIMARY KEY (StadiumID), 
    constraint UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState), 
    constraint CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

go

CREATE table Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName CHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamID), 
    constraint UQ_UniversityName UNIQUE (UniversityName),
    constraint FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

go

CREATE table Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate Date NOT NULL,
    GameTime Time NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
    constraint PK_Game PRIMARY KEY (GameID), 
    constraint UQ_Game UNIQUE (GameDate, GameTime), 
    constraint FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

go

CREATE TABLE Coach (
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName VARCHAR(100) NOT NULL,
    TeamID INT NOT NULL,
    CONSTRAINT PK_Coach PRIMARY KEY (CoachID),
    CONSTRAINT UQ_Coach_Team UNIQUE (TeamID),
    CONSTRAINT FK_Coach_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

go

CREATE TABLE Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    Year INT NOT NULL,
    SeasonWins INT NOT NULL,
    SeasonLosses INT NOT NULL,
    SeasonTies INT NOT NULL,
    TeamID INT NOT NULL,
    CONSTRAINT PK_Roster PRIMARY KEY (RosterID),
    CONSTRAINT UQ_Roster UNIQUE (TeamID, Year),
    CONSTRAINT FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

go

CREATE TABLE GamePrediction (
    GamePredictionID INT NOT NULL IDENTITY(1,1),
    PredictionDateTime DATETIME2 NOT NULL,
    AppUserID INT NOT NULL,
    GameID INT NOT NULL,
    PredictedTeamID INT NOT NULL,
    CONSTRAINT PK_GamePrediction PRIMARY KEY (GamePredictionID),
    CONSTRAINT FK_GamePrediction_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    CONSTRAINT FK_GamePrediction_Game FOREIGN KEY (GameID) REFERENCES Game(GameID),
    CONSTRAINT FK_GamePrediction_PredictedTeam FOREIGN KEY (PredictedTeamID) REFERENCES Team(TeamID),
    CONSTRAINT UQ_GamePrediction UNIQUE (AppUserID, GameID)
);