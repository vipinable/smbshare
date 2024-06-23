#!/bin/bash
export AWS_ACCESS_KEY_ID=$(grep aws_access_key_id /home/pi/.aws/credentials | awk '{print $3}')
export AWS_SECRET_ACCESS_KEY=$(grep aws_secret_access_key /home/pi/.aws/credentials | awk '{print $3}')
export AWS_DEFAULT_REGION=us-east-1
LOG_ENTRY="$(hostname) $(uptime | tr -d ',')" 
/usr/bin/aws logs put-log-events --log-group-name healthcheck-healthchecklg51B22FD0-5U1gCWp2fGkk --log-stream-name defaultlogstream --log-events timestamp=$(date +%s%3N),message="${LOG_ENTRY}"
