import pymssql

from get_db_connection import get_db_connection

def get_all_teams_by_conference(conference:str=None):
    connection = get_db_connection()
    cursor = connection.cursor(as_dict=True)  

    # Fetch all teams from the specified conference
    cursor.execute("execute procGetAllTeamsByConference @conference = %s", (conference,))
    teams = cursor.fetchall() # multiple rows returned (one row per team)

    # Close the cursor and connection
    cursor.close()
    connection.close()

    # Convert the list of teams to a list of dictionaries
    teams_list = []
    for each_team in teams:
        teams_list.append({
            "ConferenceName": each_team["ConferenceName"],
            "TeamName": each_team["TeamName"],
            "UniversityName": each_team["UniversityName"],
        })

    return teams_list