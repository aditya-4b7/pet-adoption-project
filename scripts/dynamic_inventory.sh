#!/bin/bash
set -euo pipefail
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <region> <asg_name>"
  exit 1
fi
REGION="$1"
ASG_NAME="$2"
INVENTORY_FILE="ansible/inventory.ini"
echo "[web]" > "$INVENTORY_FILE"
INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query "AutoScalingGroups[0].Instances[*].InstanceId" --output text)
if [ -z "$INSTANCE_IDS" ] || [ "$INSTANCE_IDS" = "None" ]; then
  echo "No instances found in ASG $ASG_NAME" >&2
  exit 1
fi
for INSTANCE_ID in $INSTANCE_IDS; do
  PRIVATE_IP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$INSTANCE_ID" --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
  echo "$PRIVATE_IP ansible_user=ec2-user" >> "$INVENTORY_FILE"
done
echo "Inventory written to $INVENTORY_FILE"
