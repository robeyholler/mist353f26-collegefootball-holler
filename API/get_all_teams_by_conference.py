import pymssql
from get_db_connection import get_db_connection
def get_all_teams_by_conference(conference:str):
    connection = get_db_connection()
    cursor = connection.cursor()

    # Fetch all teams from the specified conference
    cursor.execute("{CALL GetAllTeamsByConference(%s)}", (conference,))
    teams = cursor.fetchall() # multiple rows returned (one row per team)
    # Close the cursor and connection
    cursor.close()
    connection.close()

    # Convert the list of teams to a list of dictionaries
    team_list = []
    for team in teams:
        team_list.append(
            {
                "ConferenceName": team["ConferenceName"],
                "UniversityName": team["UniversityName"],
                "TeamName": team["TeamName"],
            }
        )
    return team_list
        