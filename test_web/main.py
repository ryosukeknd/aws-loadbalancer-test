from fastapi import FastAPI
from fastapi.responses import PlainTextResponse
import os

# インスタンスの情報取得
INSTANCE_ID = os.environ.get("INSTANCE_ID", "INSTANCE_ID")

app = FastAPI()


@app.get("/",  response_class=PlainTextResponse)
async def root() -> str:
    # PID
    PID = os.getpid()
    return "OK :: {} :: pid {}".format(INSTANCE_ID, PID)
