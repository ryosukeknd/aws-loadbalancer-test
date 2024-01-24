#!/bin/bash

function callapi() {
    resp=$(curl -s http://test-nlb-b3de6b9758d1511f.elb.us-west-2.amazonaws.com)
    echo $resp
}

export -f callapi

seq 1 100 | xargs -I{} -L 1 -P 4 bash -c "callapi"
