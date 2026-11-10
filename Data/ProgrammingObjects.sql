create or alter procedure proc_GetAllTeamsInAConference
(
    @ConferenceName nvarchar(100)
)
as
begin
    select UniversityName, TeamName
    from Conference C inner join Team T 
        on C.ConferenceID = T.ConferenceID
    where C.ConferenceName = @ConferenceName;
end
select UniversityName, TeamName
from Conference C inner join Team T 
    on C.ConferenceID = T.ConferenceID
where C.ConferenceName = 'Big 12';