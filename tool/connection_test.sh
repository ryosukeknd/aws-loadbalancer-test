#!/bin/bash

export API_URL="http://test-nlb-40d57d7fbc351540.elb.us-west-2.amazonaws.com"
export LOG_FILE_PREFIX="asis.disable_cross_zone_load_balancing"
export SUMMARY_FILE="${LOG_FILE_PREFIX}.summary.txt"

rm ${LOG_FILE_PREFIX}*

function callapi() {
    resp=$(curl -s ${API_URL})
    echo $resp
}

export -f callapi

# 100回のAPI呼び出しを3並列で実行、これを5回繰り返す
for i in $(seq 1 5);do
    seq 1 100 | xargs -I{} -L 1 -P 21 bash -c "callapi" > ${LOG_FILE_PREFIX}.${i}.log
    sleep 5
done

for FILE in $(ls ${LOG_FILE_PREFIX}*.log);do
    echo "# ${FILE}" >> ${SUMMARY_FILE}
    cat ${FILE} | sort | uniq -c >> ${SUMMARY_FILE}
done
echo "# summary" >> ${SUMMARY_FILE}
cat ${LOG_FILE_PREFIX}*.log | sort | uniq -c >> ${SUMMARY_FILE}
