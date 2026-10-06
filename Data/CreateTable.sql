/*CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;*/

if object_id('Stadium') is not null
    drop table Stadium;
if object_id('AppUserTeam') is not null
    drop table AppUserTeam;
if object_id('Team') is not null
    drop table Team;
if object_id('Game') is not null
    drop table Game;
if object_id('AppUser') is not null
    drop table AppUser;
if object_id('Coach') is not null
    drop table Coach;
if object_id('Roster') is not null
    drop table Roster;
if object_id('Position') is not null
    drop table Position;
if object_id('Player') is not null
    drop table Player;
if object_id('GamePrediction') is not null
    drop table GamePrediction;
if object_id('WeeklyPredictionResults') is not null
    drop table WeeklyPredictionResults;

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

CREATE table AppUser (
    AppUserID INT NOT NULL IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    AppUserEmail VARCHAR(50) NOT NULL,
    AppUserPassword VARCHAR(50) NOT NULL,
    constraint PK_AppUser PRIMARY KEY (AppUserID), 
    constraint UQ_AppUser UNIQUE (AppUserEmail)
);

go

CREATE table AppUserTeam (
    AppUserTeamID INT NOT NULL IDENTITY(1,1),
    AppUserID INT NOT NULL,
    TeamID INT NOT NULL,
    constraint PK_AppUserTeam PRIMARY KEY (AppUserTeamID),
    constraint UQ_AppUserTeam UNIQUE (AppUserID, TeamID),
    constraint FK_AppUserTeam_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    constraint FK_AppUserTeam_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

go

CREATE TABLE Coach (
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName VARCHAR(100) NOT NULL,
    TeamID INT NULL,
    CONSTRAINT PK_Coach PRIMARY KEY (CoachID),
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

CREATE table Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(50) NOT NULL,
    constraint PK_Position PRIMARY KEY (PositionID), 
    constraint CK_Position CHECK (PositionName IN ('Quarterback', 'Running Back', 'Defender', 'Returner', 'Kicker','Punter'))
);

go

CREATE table Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerName VARCHAR(100) NOT NULL,
    PlayerDoB DATE NOT NULL,
    PositionID INT NOT NULL,
    constraint PK_Player PRIMARY KEY (PlayerID)
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

go

CREATE table WeeklyPredictionResults (
    WeeklyPredictionResultsID INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL,
    NumberOfCorrectPredictions INT NOT NULL,
    AppUserID INT NOT NULL,
    constraint PK_WeeklyPredictionResults PRIMARY KEY (WeeklyPredictionResultsID), 
    constraint FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
);
