#!/bin/bash

echo "[web]" > ansible/inventory.ini

aws ec2 describe-instances \
  --filters "Name=tag:aws:autoscaling:groupName,Values=*" \
  --query "Reservations[*].Instances[*].PrivateIpAddress" \
  --output text >> ansible/inventory.ini