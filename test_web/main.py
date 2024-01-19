from fastapi import FastAPI
from fastapi.responses import PlainTextResponse
import requests

# インスタンスの情報取得
INSTANCE_ID = "Unknown INSTANCE_ID"
try:
    url = "169.254.169.254/latest/meta-data/instance-id/"
    resp = requests.get(url)
    INSTANCE_ID = resp.text()
except Exception:
    pass


app = FastAPI()


@app.get("/",  response_class=PlainTextResponse)
async def root() -> str:
    return "OK :: {}".format(INSTANCE_ID)
