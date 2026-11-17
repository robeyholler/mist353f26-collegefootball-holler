go

create or alter procedure procGetAllTeamsInAConference
(
    @ConferenceName nvarchar(50)
)
as
begin
    select ConferenceName, UniversityName, TeamName
    from Conference C inner join Team T 
        on T.ConferenceID = C.ConferenceID
    where C.ConferenceName = @ConferenceName;
end;

--execute procGetAllTeamsInAConference @ConferenceName = 'Big 12';
go

--optionality for user input
create or alter procedure procGetAllTeamsInAConference
(
    @ConferenceName nvarchar(50) = null
)
as
begin
    select ConferenceName, UniversityName, TeamName
    from Conference C inner join Team T 
        on T.ConferenceID = C.ConferenceID
    --where @ConferenceName is null or C.ConferenceName = @ConferenceName;
    where C.ConferenceName = IsNull(@ConferenceName, C.ConferenceName);
end;

/*
execute procGetAllTeamsInAConference @ConferenceName = 'Big 12';
execute procGetAllTeamsInAConference;
*/
GO

create or alter procedure procScheduleGames
(
    @homeTeamID int,
    @awayTeamID int,
    @gameDate date,
    @gameTime time,
    @stadiumID int, 
    @gameID int output
)
as
begin
    declare @gameID int;

    insert into Game (homeTeamID, awayTeamID, gameDate, gameTime, stadiumID)
    values (@homeTeamID, @awayTeamID, @gameDate, @gameTime, @stadiumID);

    set @gameID = scope_identity();

end;
/*
execute procScheduleGames @homeTeamID = 1, @awayTeamID = 2, @gameDate = '2026-11-14', @gameTime = '19:00', @stadiumID = 1, gameID = @gameID output;
print @gameID;
*/