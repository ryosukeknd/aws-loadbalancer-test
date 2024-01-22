from fastapi import FastAPI
from fastapi.responses import PlainTextResponse
import requests

# インスタンスの情報取得
INSTANCE_ID = "Unknown INSTANCE_ID"
try:
    resp = requests.put(
        "http://169.254.169.254/latest/api/token",
        headers={
            "X-aws-ec2-metadata-token-ttl-seconds": 300
        }
    )
    token = resp.text()

    resp = requests.get(
        "http://169.254.169.254/latest/meta-data/instance-id",
        headers={
            "X-aws-ec2-metadata-token": token
        }
    )
    INSTANCE_ID = resp.text()
except Exception:
    pass


app = FastAPI()


@app.get("/",  response_class=PlainTextResponse)
async def root() -> str:
    return "OK :: {}".format(INSTANCE_ID)
