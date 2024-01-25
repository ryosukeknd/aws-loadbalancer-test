#!/bin/bash
echo "##########################################################"
echo "# Run user data"
echo "##########################################################"
su - ec2-user <<EOF
cd ~/aws-loadbalancer-test/test_web
bash ./run.sh &
EOF
