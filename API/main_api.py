from fastapi import FastAPI
from .get_all_teams_by_conference import get_all_teams_by_conference
app = FastAPI()

@app.get("/get_all_teams_by_conference")
def get_teams_by_conference(conference: str = None):

    return get_all_teams_by_conference(conference)