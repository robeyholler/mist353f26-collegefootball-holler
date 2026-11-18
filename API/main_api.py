import fastapi
from fastapi import FastAPI
from get_all_teams_by_conference import get_all_teams_by_conference

app = FastAPI()

@app.get("/api/teams")
def get_all_teams_by_conference_endpoint(conference: str):
    teams = get_all_teams_by_conference(conference)
    return {"teams": teams}
