from fastapi import FastAPI
from fastapi.responses import PlainTextResponse
import os

# インスタンスの情報取得
INSTANCE_ID = os.environ.get("INSTANCE_ID", "INSTANCE_ID")


app = FastAPI()


@app.get("/",  response_class=PlainTextResponse)
async def root() -> str:
    return "OK :: {}".format(INSTANCE_ID)
