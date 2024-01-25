#!/bin/bash

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id`
echo ${INSTANCE_ID}

export INSTANCE_ID

gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind="0.0.0.0:8080"
