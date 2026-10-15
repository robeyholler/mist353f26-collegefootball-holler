/*CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;*/

if object_id('CoachRoster') is not null
    drop table CoachRoster;
if object_id('PunterStats') is not null 
    drop table PunterStats;
if object_id('KickerStats') is not null 
    drop table KickerStats;
if object_id('ReturnerStats') is not null 
    drop table ReturnerStats;
if object_id('DefenderStats') is not null 
    drop table DefenderStats;
if object_id('RBStats') is not null 
    drop table RBStats;
if object_id('QBStats') is not null 
    drop table QBStats;
if object_id('GamePrediction') is not null
    drop table GamePrediction;
if object_id('Coach') is not null
    drop table Coach;
if object_id('PlayerPosition') is not null
    drop table PlayerPosition;
if object_id('Position') is not null
    drop table Position;
if object_id('PlayerStats') is not null
    drop table PlayerStats;
if object_id('Player') is not null
    drop table Player;
if object_id('Roster') is not null
    drop table Roster;
if object_id('WeeklyPredictionResults') is not null
    drop table WeeklyPredictionResults;
if object_id('AppUserTeam') is not null
    drop table AppUserTeam;
if object_id('AppUser') is not null
    drop table AppUser;
if object_id('Game') is not null
    drop table Game;
if object_id('Team') is not null
    drop table Team;
if object_id('Conference') is not null
    drop table Conference;
if object_id('Stadium') is not null
    drop table Stadium;

go

CREATE table Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(50) NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState CHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField VARCHAR(20) NOT NULL,
    constraint PK_Stadium PRIMARY KEY (StadiumID), 
    constraint UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState), 
    constraint CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

go

CREATE table Conference (
    ConferenceID INT NOT NULL IDENTITY(1,1),
    ConferenceName VARCHAR(50) NOT NULL,
    constraint PK_Conference PRIMARY KEY (ConferenceID),
    constraint UQ_Conference UNIQUE (ConferenceName)
);

go

CREATE table Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    ConferenceID INT NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamID), 
    constraint UQ_UniversityName UNIQUE (UniversityName),
    constraint FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID),
    constraint FK_Team_Conference FOREIGN KEY (ConferenceID) REFERENCES Conference(ConferenceID)
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
    constraint UQ_Game UNIQUE (GameDate, GameTime, StadiumID), 
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
    AppUserRole VARCHAR(20) NOT NULL,
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

CREATE table WeeklyPredictionResults (
    WeeklyPredictionResultsID INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL DEFAULT GETDATE(),
    NumberOfCorrectPredictions INT NOT NULL DEFAULT 0,
    AppUserID INT NOT NULL,
    constraint PK_WeeklyPredictionResults PRIMARY KEY (WeeklyPredictionResultsID), 
    constraint FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
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

CREATE table Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerName VARCHAR(100) NOT NULL,
    PlayerDoB DATE NOT NULL,
    constraint PK_Player PRIMARY KEY (PlayerID),
    constraint UQ_Player UNIQUE (PlayerName, PlayerDoB)
);

go

CREATE table PlayerStats(
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    CONSTRAINT PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT UQ_PlayerStats UNIQUE (PlayerID, RosterID),
    CONSTRAINT FK_PlayerStats_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT FK_PlayerStats_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);

go

CREATE table QBStats (
    QBStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Attempts INT NOT NULL,
    Completions INT NOT NULL,
    Yards INT NOT NULL,
    TDs INT NOT NULL,
    INTs INT NOT NULL,
    CONSTRAINT PK_QBStats PRIMARY KEY (QBStatsID),
    CONSTRAINT UQ_QBStats UNIQUE (PlayerStatsID),
    CONSTRAINT FK_QBStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

go

CREATE table RBStats (
    RBStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Carries INT NOT NULL,
    Yards INT NOT NULL,
    TDs INT NOT NULL,
    Long INT NOT NULL,
    Fumbles INT NOT NULL,
    CONSTRAINT PK_RBStats PRIMARY KEY (RBStatsID),
    CONSTRAINT UQ_RBStats UNIQUE (PlayerStatsID),
    CONSTRAINT FK_RBStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

go

CREATE table DefenderStats (
    DefenderStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Tackles INT NOT NULL,
    Sacks INT NOT NULL,
    INTs INT NOT NULL,
    DefensiveTDs INT NOT NULL,
    CONSTRAINT PK_DefenderStats PRIMARY KEY (DefenderStatsID),
    CONSTRAINT UQ_QBStats UNIQUE (PlayerStatsID),
    CONSTRAINT FK_DefenderStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

go

CREATE table ReturnerStats (
    ReturnerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    KickOffAttempts INT NOT NULL,
    KickOffYards INT NOT NULL,
    KickOffLong INT NOT NULL,
    KickOffTDs INT NOT NULL,
    PuntReturnAttempts INT NOT NULL,
    PuntReturnYards INT NOT NULL,
    PuntReturnLong INT NOT NULL,
    PuntReturnTDs INT NOT NULL,
    CONSTRAINT PK_ReturnerStats PRIMARY KEY (ReturnerStatsID),
    CONSTRAINT UQ_QBStats UNIQUE (PlayerStatsID),
    CONSTRAINT FK_ReturnerStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

go

CREATE table KickerStats (
    KickerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    FieldGoalAttempts INT NOT NULL,
    FieldGoalsMade INT NOT NULL,
    Long INT NOT NULL,
    ExtraPointAttempts INT NOT NULL,
    ExtraPointsMade INT NOT NULL,
    CONSTRAINT PK_KickerStats PRIMARY KEY (KickerStatsID),
    CONSTRAINT UQ_QBStats UNIQUE (PlayerStatsID),
    CONSTRAINT FK_KickerStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

go

CREATE table PunterStats (
    PunterStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Punts INT NOT NULL,
    Yards INT NOT NULL,
    Long INT NOT NULL,
    CONSTRAINT PK_PunterStats PRIMARY KEY (PunterStatsID),
    CONSTRAINT UQ_QBStats UNIQUE (PlayerStatsID),
    CONSTRAINT FK_PunterStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

go

CREATE table Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(50) NOT NULL,
    constraint PK_Position PRIMARY KEY (PositionID), 
    constraint UQ_Position UNIQUE (PositionName),
    constraint CK_Position CHECK (PositionName IN ('QB', 'RB', 'Defender', 'Returner', 'Kicker','Punter'))
);

go

Create table PlayerPosition (
    PlayerPositionID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    PositionID INT NOT NULL,
    constraint PK_PlayerPosition PRIMARY KEY (PlayerPositionID), 
    constraint UQ_PlayerPosition UNIQUE (PlayerID, PositionID),
    constraint FK_PlayerPosition_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    constraint FK_PlayerPosition_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);

GO

CREATE TABLE Coach (
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName VARCHAR(100) NOT NULL,
    TeamID INT NULL,
    CONSTRAINT PK_Coach PRIMARY KEY (CoachID),
    CONSTRAINT FK_Coach_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

go

CREATE table CoachRoster (
    CoachRosterID INT NOT NULL IDENTITY(1,1),
    CoachID INT NOT NULL,
    RosterID INT NOT NULL,
    constraint PK_CoachRoster PRIMARY KEY (CoachRosterID), 
    constraint UQ_CoachRoster UNIQUE (CoachID, RosterID),
    constraint FK_CoachRoster_Coach FOREIGN KEY (CoachID) REFERENCES Coach(CoachID),
    constraint FK_CoachRoster_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);

go

CREATE TABLE GamePrediction (
    GamePredictionID INT NOT NULL IDENTITY(1,1),
    PredictionDateTime DATETIME2 NOT NULL,
    PredictedMargin INT NOT NULL,
    AppUserID INT NOT NULL,
    GameID INT NOT NULL,
    PredictedTeamID INT NOT NULL,
    CONSTRAINT PK_GamePrediction PRIMARY KEY (GamePredictionID),
    CONSTRAINT FK_GamePrediction_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
    CONSTRAINT FK_GamePrediction_Game FOREIGN KEY (GameID) REFERENCES Game(GameID),
    CONSTRAINT FK_GamePrediction_PredictedTeam FOREIGN KEY (PredictedTeamID) REFERENCES Team(TeamID),
    CONSTRAINT UQ_GamePrediction UNIQUE (AppUserID, GameID)
);

